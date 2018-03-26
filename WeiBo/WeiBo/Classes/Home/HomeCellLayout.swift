import UIKit

struct HomeCellLayout {
    let iconImageRect = CGRect(x: 15, y: 15, width: 40, height: 40)
    let vertifyIconRect = CGRect(x: 38, y: 38, width: 17, height: 17)
    let nameRect: CGRect
    let vipIconRect: CGRect
    let creatingDateRect: CGRect
    let sourceRect: CGRect
    
    init(viewModel: StatusViewModel) {
        if let screenName = viewModel.status.user?.screen_name {
            let nameAttributedStr = NSAttributedString(string: screenName,
                                                       attributes: [.font : UIFont.systemFont(ofSize: 14)])
            let drawingRect = nameAttributedStr.boundingRect(with: CGSize(width: kScreenW - 94, height: CGFloat(MAXFLOAT)),
                                                             options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                             context: nil)
            nameRect = CGRect(x: 70,
                              y: 15,
                              width: ceil(drawingRect.width),
                              height: ceil(drawingRect.height))
        } else {
            nameRect = CGRect.zero
        }
        
        vipIconRect = CGRect(x: nameRect.maxX + 10,
                             y: nameRect.midY - 7,
                             width: 14,
                             height: 14)
        
        if let creatingDateStr = viewModel.creatTimeStr {
            let attributedStr = NSAttributedString(string: creatingDateStr,
                                                   attributes: [.font : UIFont.systemFont(ofSize: 10)])
            let drawingRect = attributedStr.boundingRect(with: CGSize(width: kScreenW, height: CGFloat(MAXFLOAT)),
                                                         options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                         context: nil)
            creatingDateRect = CGRect(x: 70,
                                      y: iconImageRect.maxY - ceil(drawingRect.height),
                                      width: ceil(drawingRect.width),
                                      height: ceil(drawingRect.height))
        } else {
            creatingDateRect = CGRect.zero
        }
        
        if let sourceStr = viewModel.sourceText {
            let attributedStr = NSAttributedString(string: sourceStr,
                                                   attributes: [.font : UIFont.systemFont(ofSize: 10)])
            let drawingRect = attributedStr.boundingRect(with: CGSize(width: kScreenW, height: CGFloat(MAXFLOAT)),
                                                         options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                         context: nil)
            sourceRect = CGRect(x: creatingDateRect.maxX + 10,
                                y: creatingDateRect.minY,
                                width: ceil(drawingRect.width),
                                height: ceil(drawingRect.height))
        } else {
            sourceRect = CGRect.zero
        }
    }
}
