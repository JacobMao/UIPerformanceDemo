//
//  AsyncRenderLabel.swift
//  WeiBo
//
//  Created by ST21073 on 2018/04/09.
//

import UIKit

class AsyncRenderLabel: UIView {
    public typealias RETapHandler = (AsyncRenderLabel, String, NSRange) -> Void
    var linkTapHandler : RETapHandler?
    var userTapHandler : RETapHandler?
    var topicTapHandler : RETapHandler?

    var linkRanges : [NSRange] = [NSRange]()
    var userRanges : [NSRange] = [NSRange]()
    var topicRanges : [NSRange] = [NSRange]()


    var textRender: RenderObject? {
        didSet {
            layer.contents = nil
            layer.setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        isOpaque = false
        backgroundColor = UIColor.clear
        layer.contentsScale = UIScreen.main.scale
        (layer as? AsyncRenderLayer)?.asyncRenderDelegate = self

        let touchGes = UITapGestureRecognizer(target: self, action: #selector(self.handleTouchGesture))
        addGestureRecognizer(touchGes)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class var layerClass : AnyClass {
        return AsyncRenderLayer.self
    }

    @objc private func handleTouchGesture(_ gesture: UITapGestureRecognizer) {
        guard let rObj = textRender else {
            return
        }

        let touchPoint = gesture.location(in: self)
        let cIndex = rObj.characterIndex(at: touchPoint)
        for r in linkRanges {
            if r.contains(cIndex) {
                let s = rObj.attributedText.attributedSubstring(from: r).string
                linkTapHandler?(self, s, r)
                return
            }
        }

        for r in userRanges {
            if r.contains(cIndex) {
                let s = rObj.attributedText.attributedSubstring(from: r).string
                userTapHandler?(self, s, r)
                return
            }
        }

        for r in topicRanges {
            if r.contains(cIndex) {
                let s = rObj.attributedText.attributedSubstring(from: r).string
                topicTapHandler?(self, s, r)
                return
            }
        }
    }
}

extension AsyncRenderLabel: AsyncRenderLayerDelegate {
    func willAsyncRender(_ layer: CALayer) {
    }

    func asyncRendering(context: CGContext, size: CGSize, isCancelled: @escaping () -> Bool) {
        textRender?.drawAt(CGPoint.zero, isCanceled: isCancelled)
    }

    func didAsyncRender(_ layer: CALayer, finished: Bool) {
    }
}
