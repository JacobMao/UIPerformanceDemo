import UIKit
import Alamofire

enum RequestMethod  {
    case GET
    case POST
}


class NetworkTools {
    class func requestData(type:RequestMethod ,
                           URLString : String ,
                           parameters : [String : Any]? = nil ,
                           finishCallBack:@escaping (_ response : AnyObject) -> ()) {
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            guard let result = response.result.value else{
                
                print(response.error!)
                return
            }

            finishCallBack(result as AnyObject)
        }
    }
    

    class func getData(URLString : String , finishCallBack:@escaping (_ response : AnyObject) -> ()) {
        requestData(type: .GET, URLString: URLString) { (response) in
            finishCallBack(response)
        }
        
    }
}


extension NetworkTools{
    class func loadAccessToken(code : String , finishCallBack: @escaping (_ result : [String : Any]? ) -> ()) {
        let params = ["client_id" : app_key , "client_secret" : app_secret , "grant_type" : "authorization_code", "code" : code ,"redirect_uri" : redirect_uri]
        requestData(type: .POST, URLString: "https://api.weibo.com/oauth2/access_token", parameters: params) { (result) in
            finishCallBack(result as? [String : Any])
        }
    }
}

extension NetworkTools {
    class func loadUserInfo(accessToken : String ,uid : String , finishCallBack :@escaping (_ result : Any) -> ()) {
        requestData(type: .GET, URLString: "https://api.weibo.com/2/users/show.json", parameters: ["access_token" : accessToken , "uid" : uid]) { (result) in
            finishCallBack(result)
        }
    }
}


extension NetworkTools{
    class func loadHomeData(_ since_id : Int , max_id : Int , finishCallBack:@escaping (_ result : [[String : AnyObject]]? ) -> ()) {
        let jsonFilePath = Bundle.main.url(forResource: "json", withExtension: "txt")!
        let jsonData = try! Data(contentsOf: jsonFilePath)
        let statusesArray = (try! JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments])) as! [[String : AnyObject]]
        finishCallBack(statusesArray)
    }
}
