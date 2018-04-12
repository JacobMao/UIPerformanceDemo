import UIKit

class BaseViewController: UITableViewController {
    var visitorView : VisitorView = VisitorView.visitorView()
    var isLogin : Bool = false

//    override func loadView() {
//        isLogin = UserAccountViewModel.shared.isLogin
//        isLogin ? super.loadView() : setupVisitorView()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseViewController {
    fileprivate func setupVisitorView(){
        view = visitorView
        visitorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick), for: .touchUpInside)
    }
}


extension BaseViewController{
    @objc fileprivate func loginBtnClick() {
        let oauthVC = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauthVC)
        present(nav, animated: true, completion: nil)
    }
    
}
