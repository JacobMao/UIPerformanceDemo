//
//  BgTextLayer.swift
//  WeiBo
//
//  Created by ST21073 on 2018/04/11.
//

import UIKit

class BgTextLayer: CATextLayer {
    override func draw(in ctx: CGContext) {
        if isOpaque, let bgCGColor = backgroundColor {
            ctx.setFillColor(bgCGColor)
            ctx.addRect(CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
            ctx.fillPath()
        }

        super.draw(in: ctx)
    }
}
