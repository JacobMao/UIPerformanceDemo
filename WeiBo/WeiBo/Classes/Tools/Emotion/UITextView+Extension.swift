import UIKit

extension UITextView {
    func getAttributeString() -> String {
        let attrStr = NSMutableAttributedString(attributedString: attributedText)
        let range = NSMakeRange(0, attrStr.length)
        attrStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            
            Dlog("\(String(describing: dict))" + "-----" + "(\(range.location),\(range.length))")
            
            if  let attachment = dict[.attachment] as? EmotionAttchment {
                attrStr.replaceCharacters(in: range, with: attachment.chs!)
            }
            
            Dlog(attrStr.string)
        }
        
        return attrStr.string
    }
    
    
    func insertEmotionToTextView(emotion : Emotion) {
        Dlog(emotion)

        if emotion.isEmpty {
            return
        }

        if emotion.isRemove {
            
            deleteBackward()
            return
        }

        if (emotion.emojiCode != nil) {
            insertText(emotion.emojiCode!)
            return
        }

        let attachment = EmotionAttchment()
        attachment.chs = emotion.chs
        attachment.image = UIImage(contentsOfFile: emotion.pngPath!)
        let font = self.font
        attachment.bounds = CGRect(x: 0, y: -4, width: (font?.lineHeight)!, height: (font?.lineHeight)!)

        let attrImageStr = NSAttributedString(attachment: attachment)

        let attrMStr = NSMutableAttributedString(attributedString: attributedText)

        let range = selectedRange
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        
        attributedText = attrMStr

        self.font = font
        selectedRange = NSMakeRange(range.location + 1, range.length)
    }
}
