import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        
        loadWebView()
    }

}

extension OAuthViewController{
    
    fileprivate func setupNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(OAuthViewController.closeBtnClick))
    }
    
    
    fileprivate func loadWebView(){
        let Url = URL(string: authUrlStr)!
        let request = URLRequest(url: Url)
        webView.loadRequest(request)
    }
    
}

extension OAuthViewController{
    @objc fileprivate func closeBtnClick(){
        dismiss(animated: true, completion: nil)
    }
}

extension OAuthViewController : UIWebViewDelegate{
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!.absoluteString
        guard url.contains("code=") else {
            return true
        }

        let codeRange = url.range(of: "code=")!
        let code = url.substring(from: codeRange.upperBound)

        loadAcceccTokenWithCode(code: code)

        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
 
}

extension OAuthViewController{
    fileprivate func loadAcceccTokenWithCode(code : String)
    {
        NetworkTools.loadAccessToken(code: code) { (result) in

            print(result!)

            guard result != nil else{
                return
            }

            let user = UserAccount(dict: result!)
            
            print(user)

            self.loadUserInfo(user: user)
        }
    }

    fileprivate func loadUserInfo(user : UserAccount){
        NetworkTools.loadUserInfo(accessToken: user.access_token!, uid: user.uid!) { (result) in
            let userInfoDict = result as! [String : AnyObject]
            
            user.screen_name = userInfoDict["screen_name"] as? String
            user.avatar_large = userInfoDict["avatar_large"] as? String
            

            UserAccountViewModel.shared.archiveAccount(user)
            UserAccountViewModel.shared.account = user

            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
}
