import UIKit

private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10

struct HomeCellLayout {
    let iconImageRect = CGRect(x: 15, y: 15, width: 40, height: 40)
    let vertifyIconRect = CGRect(x: 38, y: 38, width: 17, height: 17)
    let nameRect: CGRect
    let vipIconRect: CGRect
    let creatingDateRect: CGRect
    let sourceRect: CGRect
    let contentRect: CGRect
    let retweetContentRect: CGRect
    let picContainerRect: CGRect
    let picViewSize: CGSize
    let retweetBGRect: CGRect
    let cellHeight: CGFloat
    
    init(viewModel: StatusViewModel) {
        if let screenName = viewModel.status.user?.screen_name {
            let drawingRect = (screenName as NSString).boundingRect(with: CGSize(width: kScreenW - 94, height: CGFloat(MAXFLOAT)),
                                                             options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                             attributes: [.font : UIFont.systemFont(ofSize: 14)],
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
            let drawingRect = (creatingDateStr as NSString).boundingRect(with: CGSize(width: kScreenW, height: CGFloat(MAXFLOAT)),
                                                                         options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                         attributes: [.font : UIFont.systemFont(ofSize: 10)],
                                                                         context: nil)
            creatingDateRect = CGRect(x: 70,
                                      y: iconImageRect.maxY - ceil(drawingRect.height),
                                      width: ceil(drawingRect.width),
                                      height: ceil(drawingRect.height))
        } else {
            creatingDateRect = CGRect.zero
        }
        
        if let sourceStr = viewModel.sourceText {
            let drawingRect = (sourceStr as NSString).boundingRect(with: CGSize(width: kScreenW, height: CGFloat(MAXFLOAT)),
                                                                   options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                   attributes: [.font : UIFont.systemFont(ofSize: 10)],
                                                                   context: nil)
            sourceRect = CGRect(x: creatingDateRect.maxX + 10,
                                y: creatingDateRect.minY,
                                width: ceil(drawingRect.width),
                                height: ceil(drawingRect.height))
        } else {
            sourceRect = CGRect.zero
        }

        var cellHeightResult: CGFloat = iconImageRect.maxY + 15
        
        if let drawingRect = viewModel.statusContent.statusAttributedStr?.boundingRect(with: CGSize(width: kScreenW - 30, height: CGFloat(MAXFLOAT)),
                                                                                       options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                                       context: nil) {
            contentRect = CGRect(x: 15,
                                 y: iconImageRect.maxY + 10,
                                 width: ceil(drawingRect.width),
                                 height: ceil(drawingRect.height))
            
            cellHeightResult = contentRect.maxY + 15
        } else {
            contentRect = CGRect.zero
        }
        viewModel.render?.setRenderSize(contentRect.size)

        if let drawingRect = viewModel.retweetContent.statusAttributedStr?.boundingRect(with: CGSize(width: kScreenW - 30, height: CGFloat(MAXFLOAT)),
                                                                                        options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                                        context: nil) {
            if contentRect != CGRect.zero {
                retweetContentRect = CGRect(x: 15,
                                            y: contentRect.maxY + 15,
                                            width: ceil(drawingRect.width),
                                            height: ceil(drawingRect.height))
            } else {
                retweetContentRect = CGRect(x: 15,
                                            y: iconImageRect.maxY + 25,
                                            width: ceil(drawingRect.width),
                                            height: ceil(drawingRect.height))
            }
        } else {
            retweetContentRect = CGRect.zero
        }
        viewModel.retweetRender?.setRenderSize(retweetContentRect.size)

        let (picContainerSize, imageViewSize) = HomeCellLayout.calculatePicViewAndItemSize(count: viewModel.picURLs.count)
        if picContainerSize != CGSize.zero {
            if retweetContentRect != CGRect.zero {
                picContainerRect = CGRect(x: 15,
                                          y: retweetContentRect.maxY + 10,
                                          width: picContainerSize.width,
                                          height: picContainerSize.height)
            } else {
                if contentRect != CGRect.zero {
                    picContainerRect = CGRect(x: 15,
                                              y: contentRect.maxY + 15,
                                              width: picContainerSize.width,
                                              height: picContainerSize.height)
                } else {
                    picContainerRect = CGRect(x: 15,
                                              y: iconImageRect.maxY + 15,
                                              width: picContainerSize.width,
                                              height: picContainerSize.height)
                }
            }
        } else {
            picContainerRect = CGRect.zero
        }

        picViewSize = imageViewSize
        
        let tempRetweetContentRect = retweetContentRect
        if tempRetweetContentRect == CGRect.zero {
            retweetBGRect = CGRect.zero
        } else {
            if picContainerRect != CGRect.zero {
                retweetBGRect = CGRect(x: 0,
                                       y: tempRetweetContentRect.minY - 8,
                                       width: kScreenW,
                                       height: (picContainerRect.maxY + 10) - (tempRetweetContentRect.minY - 8))
            } else {
                retweetBGRect = CGRect(x: 0,
                                       y: tempRetweetContentRect.minY - 8,
                                       width: kScreenW,
                                       height: tempRetweetContentRect.height + 18)
            }
        }
        
        if retweetBGRect != CGRect.zero {
            cellHeightResult = retweetBGRect.maxY
        } else {
            if picContainerRect != CGRect.zero {
                cellHeightResult = picContainerRect.maxY
            }
        }
        
        cellHeight = cellHeightResult
    }

    private static func calculatePicViewAndItemSize(count : Int) -> (CGSize, CGSize) {
        if count == 0 {
            return (CGSize.zero, CGSize.zero)
        }

        if count == 1 {
            return (CGSize(width: 150, height: 100), CGSize(width: 150, height: 100))
        }

        let imageViewWH : CGFloat = (kScreenW - 2 * edgeMargin - 2 * itemMargin) / 3
        let imageViewSize = CGSize(width: imageViewWH, height: imageViewWH)

        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin + 1
            return (CGSize(width: picViewWH, height: picViewWH), imageViewSize)
        }

        let rows = CGFloat((count - 1) / 3 + 1 )
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        let picViewW = kScreenW - 2 * edgeMargin

        return (CGSize(width: picViewW, height: picViewH), imageViewSize)
    }
}
