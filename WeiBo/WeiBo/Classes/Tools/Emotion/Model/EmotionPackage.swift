import UIKit

class EmotionPackage: NSObject {
    var emotions : [Emotion] = [Emotion]()

    init(id : String){
        super.init()
        if id == "" {
            addEmptyEmotion(isRecent: true)
            return
        }

        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        let array = NSArray.init(contentsOfFile: plistPath) as! [[String : String]]

        var index = 0
        for var dict in array {
            if var png = dict["png"] {
                png = "\(id)" + "/" + png
                dict["png"] = png
            }
            index += 1
            emotions.append(Emotion(dict : dict))

            if index == 20 {
                emotions.append(Emotion(isRemove: true))
                index = 0
            }
        }

        addEmptyEmotion(isRecent: false)
    }

    fileprivate func addEmptyEmotion(isRecent : Bool) {
        let count = emotions.count % 21
        if count == 0 && !isRecent{
            return
        }
        
        for _ in count..<20 {
            emotions.append(Emotion(isEmpty : true))
        }
        
        emotions.append(Emotion(isRemove: true))
    }
}
