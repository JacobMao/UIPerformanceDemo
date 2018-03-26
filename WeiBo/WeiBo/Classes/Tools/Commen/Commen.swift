import UIKit

let app_key = "2306563864"
let app_secret = "4470fb163c3838ba7ff8b1a0acc21773"
let redirect_uri = "http://line.me"

private let rootUrl = "https://api.weibo.com/oauth2/authorize"
let authUrlStr = "\(rootUrl)?client_id=\(app_key)&redirect_uri=\(redirect_uri)" /// authUrlstring

let baseUrl = "https://api.weibo.com/2/"
let statusPath = "\(baseUrl)statuses/"
let homgDataUrl = "\(statusPath)home_timeline.json"

let kScreenW : CGFloat = (UIScreen.screens.first?.bounds.size.width)!
let kScreenH : CGFloat = (UIScreen.screens.first?.bounds.size.height)!

func Dlog<T>(_ message : T ,file : String = #file , funName : String = #function , lineNum : Int = #line){
    let filePath = (file as NSString).lastPathComponent
    #if DEBUG
        print("\(filePath):\(funName):\(lineNum)-\n\(message)")
    #endif
}



