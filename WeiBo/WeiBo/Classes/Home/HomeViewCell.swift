import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10

class HomeViewCell: UITableViewCell {
    weak var parentVC: UIViewController?

    private lazy var iconImage1: CALayer = {
        let imageView = CALayer()
        imageView.cornerRadius = 20
        imageView.masksToBounds = true

        contentView.layer.addSublayer(imageView)

        return imageView
    }()

    private lazy var vertifyIcon1: CALayer = {
        let imageView = CALayer()

        contentView.layer.addSublayer(imageView)

        return imageView
    }()

    private lazy var userNameLabel1: CATextLayer = {
        let label = CATextLayer()
        let font = UIFont.systemFont(ofSize: 14)
        label.font = font
        label.fontSize = font.pointSize
        label.contentsScale = UIScreen.main.scale

        contentView.layer.addSublayer(label)

        return label
    }()
    
    private lazy var vipIcon1: CALayer = {
        let imageView = CALayer()
        
        contentView.layer.addSublayer(imageView)
        
        return imageView
    }()
    
    private lazy var creatAtLabel1: CATextLayer = {
        let label = CATextLayer()
        let font = UIFont.systemFont(ofSize: 10)
        label.font = font
        label.fontSize = font.pointSize
        label.contentsScale = UIScreen.main.scale
        label.foregroundColor = UIColor(red: 0.447, green: 0.447, blue: 0.447, alpha: 1).cgColor
        
        contentView.layer.addSublayer(label)
        
        return label
    }()
    
    private lazy var sourceLabel1: CATextLayer = {
        let label = CATextLayer()
        let font = UIFont.systemFont(ofSize: 10)
        label.font = font
        label.fontSize = font.pointSize
        label.contentsScale = UIScreen.main.scale
        label.foregroundColor = UIColor(red: 0.447, green: 0.447, blue: 0.447, alpha: 1).cgColor
        
        contentView.layer.addSublayer(label)
        
        return label
    }()

    private lazy var contentLabel1: AsyncRenderLabel = {
//        let label = CATextLayer()
//
//        label.contentsScale = UIScreen.main.scale
//        label.alignmentMode = kCAAlignmentLeft
//        label.isWrapped = true
//        label.backgroundColor = UIColor.red.cgColor
//        contentView.layer.addSublayer(label)

        let label = AsyncRenderLabel()
//        label.backgroundColor = UIColor.red
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.font = UIFont.systemFont(ofSize: 13)

        label.userTapHandler = { (label, user, range) in
            let alert = UIAlertController(title: nil, message: "clicked user: \(user)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.parentVC?.present(alert, animated: true, completion: nil)
        }

        label.linkTapHandler = { (label, link, range) in
            let alert = UIAlertController(title: nil, message: "clicked link: \(link)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.parentVC?.present(alert, animated: true, completion: nil)
        }

        label.topicTapHandler = { (label, topic, range) in
            let alert = UIAlertController(title: nil, message: "clicked topic: \(topic)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.parentVC?.present(alert, animated: true, completion: nil)
        }

        contentView.addSubview(label)

        return label
    }()

    private lazy var retweetContentLabel1: AsyncRenderLabel = {
//        let label = CATextLayer()
//
//        label.contentsScale = UIScreen.main.scale
//        label.alignmentMode = kCAAlignmentLeft
//        label.isWrapped = true
//        contentView.layer.addSublayer(label)

        let label = AsyncRenderLabel()
//        label.backgroundColor = UIColor.red
//        label.textAlignment = .left
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.font = UIFont.systemFont(ofSize: 13)

        label.userTapHandler = { (label, user, range) in
            let alert = UIAlertController(title: nil, message: "clicked user: \(user)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.parentVC?.present(alert, animated: true, completion: nil)
        }

        label.linkTapHandler = { (label, link, range) in
            let alert = UIAlertController(title: nil, message: "clicked link: \(link)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.parentVC?.present(alert, animated: true, completion: nil)
        }

        label.topicTapHandler = { (label, topic, range) in
            let alert = UIAlertController(title: nil, message: "clicked topic: \(topic)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.parentVC?.present(alert, animated: true, completion: nil)
        }

        contentView.addSubview(label)


        return label
    }()

    private lazy var picView1: PicCollectionView2 = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical

        let pView = PicCollectionView2(frame: CGRect.zero, collectionViewLayout: layout)
        pView.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1.0)
        pView.isScrollEnabled = false

        contentView.addSubview(pView)

        return pView
    }()
    
    private lazy var retweetStatusBGView1: CALayer = {
        let bgView = CALayer()
        bgView.backgroundColor = UIColor(red: 235.0 / 255.0,
                                         green: 235.0 / 255.0,
                                         blue: 241.0 / 255.0,
                                         alpha: 1.0).cgColor
        
        contentView.layer.addSublayer(bgView)
        
        return bgView
    }()

    private var imageOperation: SDWebImageOperation?

    // MARK: - 控件属性
    var statusVM : StatusViewModel?
    {
        didSet {
            if let viewModel = statusVM {
                imageOperation?.cancel()
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self.iconImage1.contents = nil
                CATransaction.commit()
                imageOperation = SDWebImageManager.shared().loadImage(with: statusVM?.profileURL,
                                                                      options: [],
                                                                      progress: nil) { (image, _, _, _, _, _) in
                                                                        CATransaction.begin()
                                                                        CATransaction.setDisableActions(true)
                                                                        self.iconImage1.contents = image?.cgImage
                                                                        CATransaction.commit()
                }

                CATransaction.begin()
                CATransaction.setDisableActions(true)
                vertifyIcon1.contents = viewModel.verifiedImage?.cgImage
                CATransaction.commit()

                CATransaction.begin()
                CATransaction.setDisableActions(true)
                vipIcon1.contents = viewModel.vipImage?.cgImage
                CATransaction.commit()
                
                userNameLabel1.string = viewModel.status.user?.screen_name
                userNameLabel1.foregroundColor  = (viewModel.vipImage == nil ? UIColor.black : UIColor.orange).cgColor

                creatAtLabel1.string = viewModel.creatTimeStr
                
                sourceLabel1.string = viewModel.sourceText

                contentLabel1.textRender = viewModel.render
//                contentLabel1.attributedText = viewModel.statusContent.statusAttributedStr
                contentLabel1.linkRanges = viewModel.statusContent.linkRanges
                contentLabel1.userRanges = viewModel.statusContent.userRanges
                contentLabel1.topicRanges = viewModel.statusContent.topicRanges

                retweetContentLabel1.textRender = viewModel.retweetRender
                retweetContentLabel1.linkRanges = viewModel.retweetContent.linkRanges
                retweetContentLabel1.userRanges = viewModel.retweetContent.userRanges
                retweetContentLabel1.topicRanges = viewModel.retweetContent.topicRanges

                picView1.picUrls = (statusVM?.picURLs)!
            }
        }
    }

    func setupLayout(_ layout: HomeCellLayout) {
        if iconImage1.bounds.isEmpty {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            iconImage1.frame = layout.iconImageRect
            CATransaction.commit()
        }

        if vertifyIcon1.bounds.isEmpty {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            vertifyIcon1.frame = layout.vertifyIconRect
            CATransaction.commit()
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        userNameLabel1.frame = layout.nameRect
        CATransaction.commit()
        
        if vipIcon1.frame != layout.vipIconRect {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            vipIcon1.frame = layout.vipIconRect
            CATransaction.commit()
        }
        
        if creatAtLabel1.frame != layout.creatingDateRect {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            creatAtLabel1.frame = layout.creatingDateRect
            CATransaction.commit()
        }
        
        if sourceLabel1.frame != layout.sourceRect {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            sourceLabel1.frame = layout.sourceRect
            CATransaction.commit()
        }

        contentLabel1.frame = layout.contentRect
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        retweetStatusBGView1.frame = layout.retweetBGRect
        CATransaction.commit()

        retweetContentLabel1.frame = layout.retweetContentRect
        
        picView1.frame = layout.picContainerRect
        let picLayout = picView1.collectionViewLayout as! UICollectionViewFlowLayout
        if layout.picViewSize != CGSize.zero {
            picLayout.itemSize = layout.picViewSize
        }
    }
}
