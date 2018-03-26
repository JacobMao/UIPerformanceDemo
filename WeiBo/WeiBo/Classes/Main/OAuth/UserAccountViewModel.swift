import UIKit

class UserAccountViewModel: NSObject {
    static let shared : UserAccountViewModel = UserAccountViewModel()

    var account : UserAccount?

    var accountPath : String {
        
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        path = (path as NSString).strings(byAppendingPaths: ["account.plist"]).first!
        
        print("Path : " + path)
        
        return path
    }

    var isLogin : Bool {
        guard let userAccount = account else { return false }
        
        guard let expiresDate = userAccount.expires_date else {
            return false
        }
        
        if expiresDate.compare(Date()) == ComparisonResult.orderedDescending {
            return true
        }else{
            return false
        }
    }

    override init() {
        super.init()
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount

    }

    func archiveAccount(_ account : UserAccount) {
        NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)
    }
}
