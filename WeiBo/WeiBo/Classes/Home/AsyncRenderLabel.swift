//
//  AsyncRenderLabel.swift
//  WeiBo
//
//  Created by ST21073 on 2018/04/09.
//

import UIKit

class AsyncRenderLabel: UIView {
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class var layerClass : AnyClass {
        return AsyncRenderLayer.self
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
