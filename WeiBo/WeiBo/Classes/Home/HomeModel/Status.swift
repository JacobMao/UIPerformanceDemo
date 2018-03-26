import UIKit

class Status: NSObject {
    
    var created_at : String?                /// 微博创建时间
    var text : String?                      /// 微博正文
    var source : String?                    /// 微博来源
    var mid : Int = 0                       /// 微博ID
    var user : User?                        /// 用户类型
    var pic_urls : [[String : String]]?     /// 微博配图
    var retweeted_status : Status?           /// 转发微博
    
    
    
    override init() {
        super.init()
    }
    
    init(dict : [String : AnyObject]){
        super.init()
        
        setValuesForKeys(dict)

        if let userDict = dict["user"] as? [String : AnyObject] {
            user = User.init(dict: userDict)
        }
        
        if let retweetStatusDict = dict["retweeted_status"] {
            retweeted_status = Status.init(dict: retweetStatusDict as! [String : AnyObject])
        }

    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {  }

}
