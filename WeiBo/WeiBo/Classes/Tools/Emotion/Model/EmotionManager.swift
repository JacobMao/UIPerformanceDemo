import UIKit

class EmotionManager: NSObject {
    var packages : [EmotionPackage] = [EmotionPackage]()

    override init() {
        packages.append(EmotionPackage(id: ""))
        packages.append(EmotionPackage(id: "com.sina.default"))
        packages.append(EmotionPackage(id: "com.apple.emoji"))
        packages.append(EmotionPackage(id: "com.sina.lxh"))
    }
}
