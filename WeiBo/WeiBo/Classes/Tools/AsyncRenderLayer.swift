//
//  AsyncRenderLayer.swift
//  WeiBo
//
//  Created by ST21073 on 2018/04/09.
//

import UIKit
import QuartzCore

private class AsyncSentinel {
    private let _locker = NSLock()
    private var _value = 0

    func value() -> Int {
        var result = 0

        _locker.lock()
        result = _value
        _locker.unlock()

        return result
    }

    func increase() {
        _locker.lock()
        _value += 1
        _locker.unlock()
    }
}

private let asyncRenderQueue: DispatchQueue = {
    return DispatchQueue(label: "AsyncRenderQueue",
                         qos: .userInitiated,
                         attributes: [.concurrent])
}()

protocol AsyncRenderLayerDelegate: class {
    func willAsyncRender(_ layer: CALayer) -> Void
    func asyncRendering(context: CGContext, size: CGSize, isCancelled: @escaping () -> Bool ) -> Void
    func didAsyncRender(_ layer: CALayer, finished: Bool) -> Void
}

class AsyncRenderLayer: CALayer {
    weak var asyncRenderDelegate: AsyncRenderLayerDelegate?

    private let _sentinel = AsyncSentinel()

    override init() {
        super.init()

        contentsScale = UIScreen.main.scale
        isOpaque = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setNeedsDisplay() {
        _sentinel.increase()
        super.setNeedsDisplay()
    }

    override func display() {
        super.contents = super.contents
        asyncRender()
    }

    func cancelAsyncRender() {
        _sentinel.increase()
    }

    private func asyncRender() {
        asyncRenderDelegate?.willAsyncRender(self)

        let renderSize = bounds.size
        if renderSize.width < 0.1 || renderSize.height < 0.1 {
            contents = nil
            asyncRenderDelegate?.didAsyncRender(self, finished: true)
            return
        }

        let sentinelValue = _sentinel.value()
        let sentineObject = _sentinel
        let isCancelledBlock = {
            return sentinelValue != sentineObject.value()
        }

        let opaqueFlag = isOpaque
        let scaleFactor = contentsScale
        let bgColor: UIColor? = (opaqueFlag && backgroundColor != nil) ? UIColor(cgColor: backgroundColor!) : nil
        asyncRenderQueue.async {
            if isCancelledBlock() {
                return
            }

            UIGraphicsBeginImageContextWithOptions(renderSize, opaqueFlag, scaleFactor)
            guard let context = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndImageContext()
                return
            }

            if opaqueFlag, let bgCGColor = bgColor?.cgColor {
                context.saveGState()
                context.setFillColor(bgCGColor)
                context.addRect(CGRect(x: 0, y: 0, width: renderSize.width * scaleFactor, height: renderSize.height * scaleFactor))
                context.fillPath()
                context.restoreGState()
            }

            self.asyncRenderDelegate?.asyncRendering(context: context, size: renderSize, isCancelled: isCancelledBlock)

            if isCancelledBlock() {
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    self.asyncRenderDelegate?.didAsyncRender(self, finished: false)
                }
                return
            }

            let renderImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            if isCancelledBlock() {
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    self.asyncRenderDelegate?.didAsyncRender(self, finished: false)
                }
                return
            }

            DispatchQueue.main.async {
                if isCancelledBlock() {
                    self.asyncRenderDelegate?.didAsyncRender(self, finished: false)
                } else {
                    self.contents = renderImage?.cgImage
                    self.asyncRenderDelegate?.didAsyncRender(self, finished: true)
                }
            }
        }
    }
}
