import UIKit
import SDWebImage

private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10

class HomeViewCell: UITableViewCell {
    private lazy var iconImage1: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true

        contentView.addSubview(imageView)

        return imageView
    }()

    private lazy var vertifyIcon1: UIImageView = {
        let imageView = UIImageView()

        contentView.addSubview(imageView)

        return imageView
    }()

    private lazy var userNameLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)

        contentView.addSubview(label)

        return label
    }()
    
    private lazy var vipIcon1: UIImageView = {
        let imageView = UIImageView()
        
        contentView.addSubview(imageView)
        
        return imageView
    }()
    
    private lazy var creatAtLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(red: 0.447, green: 0.447, blue: 0.447, alpha: 1)
        
        contentView.addSubview(label)
        
        return label
    }()
    
    private lazy var sourceLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(red: 0.447, green: 0.447, blue: 0.447, alpha: 1)
        
        contentView.addSubview(label)
        
        return label
    }()

    private lazy var contentLabel1: RELabel2 = {
        let label = RELabel2()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 13)

        contentView.addSubview(label)

        return label
    }()

    private lazy var retweetContentLabel1: RELabel2 = {
        let label = RELabel2()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 13)

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

        contentView.addSubview(pView)

        return pView
    }()

    // MARK: - 控件属性
    var statusVM : StatusViewModel?
    {
        didSet{
            
            if let viewModel = statusVM {

                iconImage.sd_setImage(with: statusVM?.profileURL)
                iconImage1.sd_setImage(with: statusVM?.profileURL)
                
                vertifyIcon.image = viewModel.verifiedImage
                vertifyIcon1.image = viewModel.verifiedImage

                userNameLabel.text = viewModel.status.user?.screen_name
                userNameLabel.textColor = vipIcon.image == nil ? UIColor.black : UIColor.orange
                userNameLabel1.text = viewModel.status.user?.screen_name
                userNameLabel1.textColor = vipIcon.image == nil ? UIColor.black : UIColor.orange

                vipIcon.image = viewModel.vipImage
                vipIcon1.image = viewModel.vipImage

                creatAtLabel.text = viewModel.creatTimeStr
                creatAtLabel1.text = viewModel.creatTimeStr
                
                sourceLabel.text = viewModel.sourceText
                sourceLabel1.text = viewModel.sourceText

                contentLabel.attributedText = viewModel.statusContent.statusAttributedStr
                contentLabel1.attributedText = viewModel.statusContent.statusAttributedStr
                contentLabel1.linkRanges = viewModel.statusContent.linkRanges
                contentLabel1.userRanges = viewModel.statusContent.userRanges
                contentLabel1.topicRanges = viewModel.statusContent.topicRanges

                retweetContentLabel1.attributedText = viewModel.retweetContent.statusAttributedStr
                retweetContentLabel1.linkRanges = viewModel.retweetContent.linkRanges
                retweetContentLabel1.userRanges = viewModel.retweetContent.userRanges
                retweetContentLabel1.topicRanges = viewModel.retweetContent.topicRanges

                picView1.picUrls = (statusVM?.picURLs)!

                // 计算picView的宽度和高度                
                picViewHcons.constant = self.calculatePicViewSize(count: (statusVM?.picURLs.count ?? 0)! ).height
                picVIewWcons.constant = self.calculatePicViewSize(count: (statusVM?.picURLs.count ?? 0)! ).width
                picView.picUrls = (statusVM?.picURLs)!
                // 设置转发微博的内容
                if let retweetText = statusVM?.status.retweeted_status?.text , let screenName = statusVM?.status.retweeted_status?.user?.screen_name {

                    retweetContentLabel.text = "@" + "\(screenName):" + retweetText
                    
                    // 设置装发微博背景
                    retweetStatusBGView.isHidden = false
                    
                    // 设置转发正文的约束
                    retweetContentBottomCons.constant = 10
                    
                }else{
                    retweetContentLabel.text = nil
                    retweetStatusBGView.isHidden = true
                    
                    // 设置转发正文的约束
                    retweetContentBottomCons.constant = 0
                }
                
                // 手动计算cell高度
                if viewModel.cellHeight == 0 {
                    
                    // 1.强制布局
                    self.layoutIfNeeded()
                    
                    // 2.计算并保存cell高度
                    viewModel.cellHeight = self.bottomToolBar.frame.maxY
                }
                
                // MARK: - RELabel监听点击
                
                // 监听用户的点击
                contentLabel.userTapHandler = { (label, user, range) in
                    print(label)
                    print(user)
                    print(range)
                }
                
                // 监听链接的点击
                contentLabel.linkTapHandler = { (label, link, range) in
                    print(label)
                    print(link)
                    print(range)
                }
                
                // 监听话题的点击
                contentLabel.topicTapHandler = { (label, topic, range) in
                    print(label)
                    print(topic)
                    print(range)
                }
                
                // 监听用户的点击
                retweetContentLabel.userTapHandler = { (label, user, range) in
                    print(label)
                    print(user)
                    print(range)
                }
                
                // 监听链接的点击
                retweetContentLabel.linkTapHandler = { (label, link, range) in
                    print(label)
                    print(link)
                    print(range)
                }
                
                // 监听话题的点击
                retweetContentLabel.topicTapHandler = { (label, topic, range) in
                    print(label)
                    print(topic)
                    print(range)
                }

                
            }
        }
    }

    /// 正文宽度约束
    @IBOutlet weak var contentLabelWidthConstraint: NSLayoutConstraint!
    /// picView 的高度约束
    @IBOutlet weak var picViewHcons: NSLayoutConstraint!
    /// picView 的宽度约束
    @IBOutlet weak var picVIewWcons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetContentBottomCons: NSLayoutConstraint!
    
    
    
    /// 用户头像
    @IBOutlet weak var iconImage: UIImageView!
    /// 认证图标
    @IBOutlet weak var vertifyIcon: UIImageView!
    /// 会员图标
    @IBOutlet weak var vipIcon: UIImageView!
    /// 用户昵称
    @IBOutlet weak var userNameLabel: UILabel!
    /// 创建时间
    @IBOutlet weak var creatAtLabel: UILabel!
    /// 微博来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 微博正文
    @IBOutlet weak var contentLabel: RELabel!
    /// 微博图片内容
    @IBOutlet weak var picView: PicCollectionView!
    /// 转发微博内容
    @IBOutlet weak var retweetContentLabel: RELabel!
    /// 转发微博背景
    @IBOutlet weak var retweetStatusBGView: UIView!
    /// 底部工具栏
    @IBOutlet weak var bottomToolBar: UIView!

    
    // MARK: - 系统回调
    override func awakeFromNib() {
        super.awakeFromNib()

        contentLabelWidthConstraint.constant = kScreenW - 2 * 15
    }

    func setupLayout(_ layout: HomeCellLayout) {
        if iconImage1.bounds.isEmpty {
            iconImage1.frame = layout.iconImageRect
        }

        if vertifyIcon1.bounds.isEmpty {
            vertifyIcon1.frame = layout.vertifyIconRect
        }

        userNameLabel1.frame = layout.nameRect
        
        if vipIcon1.frame != layout.vipIconRect {
            vipIcon1.frame = layout.vipIconRect
        }
        
        if creatAtLabel1.frame != layout.creatingDateRect {
            creatAtLabel1.frame = layout.creatingDateRect
        }
        
        if sourceLabel1.frame != layout.sourceRect {
            sourceLabel1.frame = layout.sourceRect
        }

        contentLabel1.frame = layout.contentRect
        retweetContentLabel1.frame = layout.retweetContentRect

        picView1.frame = layout.picContainerRect
        let picLayout = picView1.collectionViewLayout as! UICollectionViewFlowLayout
        picLayout.itemSize = layout.picViewSize
    }
}


extension HomeViewCell{
    fileprivate func calculatePicViewSize(count : Int) -> CGSize {
        // 1.没有配图
        if count == 0 {
            // 修改picView底部约束
            picViewBottomCons.constant = 0
            
            return CGSize.zero
        }
        
        // 修改picView底部约束
        picViewBottomCons.constant = 10
        
        // 2.取到collectionView的layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout

        
        // 3.单张配图
        if count == 1 {
            
            // 3.1取出缓存图片，根据该图片的Size进行返回
            let imageurl = self.statusVM?.picURLs.first?.absoluteString
            
            if let image = SDWebImageManager.shared().imageCache?.imageFromCache(forKey: imageurl)
             {
                // 3.2 设置单张配图的layout.itemSize
                layout.itemSize = CGSize(width: ((image.size.width) * 2) > 150 ? 150 : ((image.size.width) * 2 ),
                                         height: (image.size.height) * 2 > 100 ? 100 : (image.size.height) * 2)
                // 3.3.返回对应的size
                return layout.itemSize
            }
            
        }
        
        // 4.计算多张配图imageView的WH
        let imageViewWH : CGFloat = (kScreenW - 2 * edgeMargin - 2 * itemMargin) / 3
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)

        
        // 5.张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin + 1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        // 6.其他张数配图
        let rows = CGFloat((count - 1) / 3 + 1 )
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        let picViewW = kScreenW - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
        
    }
}
