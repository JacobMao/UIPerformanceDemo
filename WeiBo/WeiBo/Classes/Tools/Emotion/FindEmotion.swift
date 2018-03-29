import UIKit

class FindEmotionManager: NSObject {
    static let shared : FindEmotionManager = FindEmotionManager()

    private lazy var manager : EmotionManager = EmotionManager()

    func findAttrString(statusText : String?, font : UIFont) -> NSMutableAttributedString? {
        guard let statusText = statusText else {
            return nil
        }

        let pattern = "\\[.*?\\]"

        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }

        let results = regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.count))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attrMStr = NSMutableAttributedString(string: statusText, attributes: [.font : font])
        attrMStr.setAttributes([.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: 0))
        
        var i = results.count - 1
        while i >= 0 {
            let result = results[i]
            let chs = (statusText as NSString).substring(with: result.range)
            guard let pngPath = findPngPath(chs: chs) else {
                return nil
            }

            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)

            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)

            i -= 1
        }

        return attrMStr
    }
    
    private func findPngPath(chs : String) -> String? {
        for package in manager.packages {
            for emotion in package.emotions {
                if emotion.chs == chs {
                    return emotion.pngPath
                }
            }
        }
        
        return nil
    }


}
