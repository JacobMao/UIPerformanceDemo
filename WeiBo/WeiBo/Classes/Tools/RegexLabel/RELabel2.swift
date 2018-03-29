import UIKit

class RELabel2: UILabel {
    override var text: String?{
        didSet{
            prepareText()
        }
    }

    override var attributedText: NSAttributedString?{
        didSet{
            prepareText()
        }
    }

    override var font: UIFont!{
        didSet{
            prepareText()
        }
    }

    override var textColor: UIColor!{
        didSet{
            prepareText()
        }
    }

    fileprivate lazy var textStorage : NSTextStorage = NSTextStorage()
    fileprivate lazy var layoutManager : NSLayoutManager = NSLayoutManager()
    fileprivate lazy var textContainer : NSTextContainer = NSTextContainer()

    var linkRanges : [NSRange] = [NSRange]()
    var userRanges : [NSRange] = [NSRange]()
    var topicRanges : [NSRange] = [NSRange]()

    fileprivate var selectedRange : NSRange?
    fileprivate var isSelected : Bool = false
    fileprivate var tapHandlerType : TapHandlerType = TapHandlerType.NoneTapHandler

    public typealias RETapHandler = (RELabel, String, NSRange) -> Void
    var linkTapHandler : RETapHandler?
    var userTapHandler : RETapHandler?
    var topicTapHandler : RETapHandler?

    override init(frame: CGRect) {
        super.init(frame: frame)

        prepareTextSystem()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        prepareTextSystem()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        textContainer.size = frame.size
    }

    override open func drawText(in rect: CGRect) {
        if selectedRange != nil {
            let selectedColor = isSelected ? UIColor(white: 0.7, alpha: 0.2) : UIColor.clear
            textStorage.addAttribute(NSAttributedStringKey.backgroundColor, value: selectedColor, range: selectedRange!)
            layoutManager.drawBackground(forGlyphRange: selectedRange!, at: CGPoint(x: 0, y: 0))
        }

        let range = NSRange(location: 0, length: textStorage.length)
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint.zero)
    }

}


extension RELabel2 {
    fileprivate func prepareTextSystem() {
        prepareText()
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        isUserInteractionEnabled = true
        textContainer.lineFragmentPadding = 0
    }

    fileprivate func prepareText() {
        let attrString : NSAttributedString
        if attributedText != nil {
            attrString = attributedText!
        } else if text != nil {
            attrString = NSAttributedString(string: text!)
        } else {
            attrString = NSAttributedString(string: "")
        }

        selectedRange = nil


        let attrStringM = NSMutableAttributedString(attributedString: attrString)

        textStorage.setAttributedString(attrStringM)

        setNeedsDisplay()
    }
}





