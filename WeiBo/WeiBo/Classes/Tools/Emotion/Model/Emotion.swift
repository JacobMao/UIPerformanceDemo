import UIKit

class Emotion: NSObject {
    var code : String?
    {
        didSet{
            guard let code = code else {
                return
            }
            
            let scanner = Scanner(string: code)
            
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            
            let scalar = UnicodeScalar(value)
            let c = Character(scalar!)
            
            emojiCode = String(c)
        }
    }

    var png : String?
    {
        didSet{
            guard let png = png else {
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }

    var chs : String?
    var pngPath : String?
    var emojiCode : String?
    var isRemove : Bool = false
    var isEmpty : Bool = false
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    init(isRemove : Bool){
        super.init()
        self.isRemove = isRemove
    }
    
    init(isEmpty : Bool){
        super.init()
        self.isEmpty = isEmpty
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {    }
    
    override var description: String{
        return dictionaryWithValues(forKeys: ["emojiCode","pngPath","chs"]).description
    }

}
