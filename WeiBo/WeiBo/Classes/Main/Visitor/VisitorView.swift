import UIKit

class VisitorView: UIView {
    class func visitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }

    @IBOutlet weak var loginBtn: UIButton!
}
