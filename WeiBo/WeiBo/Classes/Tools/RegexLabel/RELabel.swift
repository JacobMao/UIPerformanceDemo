import UIKit

enum TapHandlerType {
    case NoneTapHandler
    case UserTapHandler
    case TopicTapHandler
    case LinkTapHandler
}

class RELabel: UILabel {
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
    
    var matchTextColor : UIColor = UIColor(red: 87 / 255.0, green: 196 / 255.0, blue: 251 / 255.0, alpha: 1.0){
        didSet{
            prepareText()
        }
    }

    fileprivate lazy var textStorage : NSTextStorage = NSTextStorage()
    fileprivate lazy var layoutManager : NSLayoutManager = NSLayoutManager()
    fileprivate lazy var textContainer : NSTextContainer = NSTextContainer()

    fileprivate lazy var linkRanges : [NSRange] = [NSRange]()
    fileprivate lazy var userRanges : [NSRange] = [NSRange]()
    fileprivate lazy var topicRanges : [NSRange] = [NSRange]()

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


extension RELabel {
    fileprivate func prepareTextSystem() {
        prepareText()
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        isUserInteractionEnabled = true
        textContainer.lineFragmentPadding = 0
    }

    fileprivate func prepareText() {
        var attrString : NSAttributedString?
        if attributedText != nil {
            attrString = attributedText
        } else if text != nil {
            attrString = NSAttributedString(string: text!)
        } else {
            attrString = NSAttributedString(string: "")
        }
        
        selectedRange = nil
        

        let attrStringM = addLineBreak(attrString!)
        
        attrStringM.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location: 0, length: attrStringM.length))

        textStorage.setAttributedString(attrStringM)

        if let linkRanges = getLinkRanges() {
            self.linkRanges = linkRanges
            for range in linkRanges {
                textStorage.addAttribute(NSAttributedStringKey.foregroundColor, value: matchTextColor, range: range)
            }
        }

        if let userRanges = getRanges("@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*") {
            self.userRanges = userRanges
            for range in userRanges {
                textStorage.addAttribute(NSAttributedStringKey.foregroundColor, value: matchTextColor, range: range)
            }
        }

        if let topicRanges = getRanges("#.*?#") {
            self.topicRanges = topicRanges
            for range in topicRanges {
                textStorage.addAttribute(NSAttributedStringKey.foregroundColor, value: matchTextColor, range: range)
            }
        }

        setNeedsDisplay()
    }
}

extension RELabel {
    fileprivate func getRanges(_ pattern : String) -> [NSRange]? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        return getRangesFromResult(regex)
    }
    
    fileprivate func getLinkRanges() -> [NSRange]? {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return nil
        }
        
        return getRangesFromResult(detector)
    }
    
    fileprivate func getRangesFromResult(_ regex : NSRegularExpression) -> [NSRange] {
        let results = regex.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))

        var ranges = [NSRange]()
        for res in results {
            ranges.append(res.range)
        }
        
        return ranges
    }
}

extension RELabel {
    fileprivate func addLineBreak(_ attrString: NSAttributedString) -> NSMutableAttributedString {
        let attrStringM = NSMutableAttributedString(attributedString: attrString)
        
        if attrStringM.length == 0 {
            return attrStringM
        }
        
        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        var paragraphStyle = attributes[NSAttributedStringKey.paragraphStyle] as? NSMutableParagraphStyle
        
        if paragraphStyle != nil {
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
        } else {
            paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle!.lineBreakMode = NSLineBreakMode.byWordWrapping
            attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
            
            attrStringM.setAttributes(attributes, range: range)
        }
        
        return attrStringM
    }
}




