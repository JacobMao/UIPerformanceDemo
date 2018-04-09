//
//  RenderObject.swift
//  WeiBo
//
//  Created by ST21073 on 2018/04/09.
//

import UIKit

class RenderObject {
    private let _textStorage: NSTextStorage
    private let _layoutManager: NSLayoutManager
    private let _textContainer: NSTextContainer
    private var _textBound = CGRect.zero

    var textBound: CGRect {
        return _textBound
    }

    var visiblePlyphRange: NSRange {
        return _layoutManager.glyphRange(for: _textContainer)
    }

    init(attributedText: NSAttributedString) {
        _textContainer = NSTextContainer()
        _textContainer.lineFragmentPadding = 0
        _layoutManager = NSLayoutManager()
        _layoutManager.addTextContainer(_textContainer)
        _textStorage = NSTextStorage(attributedString: attributedText)
        _textStorage.addLayoutManager(_layoutManager)
    }

    func setRenderSize(_ size: CGSize) {
        if _textContainer.size != size {
            _textContainer.size = size
        }
    }

    func drawAt(_ point: CGPoint, isCanceled: @escaping () -> Bool) {
        let glyphRange = _layoutManager.glyphRange(for: _textContainer)
        _layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { [weak self] (_, _, _, gRange, stop) in
            self?._layoutManager.drawBackground(forGlyphRange: gRange, at: CGPoint.zero)
            if isCanceled() {
                stop.pointee = true
                return
            }

            self?._layoutManager.drawGlyphs(forGlyphRange: gRange, at: CGPoint.zero)
            if isCanceled() {
                stop.pointee = true
                return
            }
        }
    }
}
