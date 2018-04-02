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

    private lazy var contentLabel1: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 13)

        contentView.addSubview(label)

        return label
    }()

    private lazy var retweetContentLabel1: UILabel = {
        let label = UILabel()
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
    
    private lazy var retweetStatusBGView1: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red: 235.0 / 255.0,
                                         green: 235.0 / 255.0,
                                         blue: 241.0 / 255.0,
                                         alpha: 1.0)
        
        contentView.addSubview(bgView)
        
        return bgView
    }()
    

    // MARK: - 控件属性
    var statusVM : StatusViewModel?
    {
        didSet {
            if let viewModel = statusVM {
                iconImage1.sd_setImage(with: statusVM?.profileURL)
                
                vertifyIcon1.image = viewModel.verifiedImage
                vipIcon1.image = viewModel.vipImage
                
                userNameLabel1.text = viewModel.status.user?.screen_name
                userNameLabel1.textColor = vipIcon1.image == nil ? UIColor.black : UIColor.orange

                creatAtLabel1.text = viewModel.creatTimeStr
                
                sourceLabel1.text = viewModel.sourceText

                contentLabel1.attributedText = viewModel.statusContent.statusAttributedStr
//                contentLabel1.linkRanges = viewModel.statusContent.linkRanges
//                contentLabel1.userRanges = viewModel.statusContent.userRanges
//                contentLabel1.topicRanges = viewModel.statusContent.topicRanges

                retweetContentLabel1.attributedText = viewModel.retweetContent.statusAttributedStr
//                retweetContentLabel1.linkRanges = viewModel.retweetContent.linkRanges
//                retweetContentLabel1.userRanges = viewModel.retweetContent.userRanges
//                retweetContentLabel1.topicRanges = viewModel.retweetContent.topicRanges

                picView1.picUrls = (statusVM?.picURLs)!
                
                // MARK: - RELabel监听点击
                
                // 监听用户的点击
//                contentLabel1.userTapHandler = { (label, user, range) in
//                    print(label)
//                    print(user)
//                    print(range)
//                }
                
                // 监听链接的点击
//                contentLabel1.linkTapHandler = { (label, link, range) in
//                    print(label)
//                    print(link)
//                    print(range)
//                }
                
                // 监听话题的点击
//                contentLabel1.topicTapHandler = { (label, topic, range) in
//                    print(label)
//                    print(topic)
//                    print(range)
//                }
                
                // 监听用户的点击
//                retweetContentLabel1.userTapHandler = { (label, user, range) in
//                    print(label)
//                    print(user)
//                    print(range)
//                }
                
                // 监听链接的点击
//                retweetContentLabel1.linkTapHandler = { (label, link, range) in
//                    print(label)
//                    print(link)
//                    print(range)
//                }
                
                // 监听话题的点击
//                retweetContentLabel1.topicTapHandler = { (label, topic, range) in
//                    print(label)
//                    print(topic)
//                    print(range)
//                }

                
            }
        }
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
        
        retweetStatusBGView1.frame = layout.retweetBGRect
        
        retweetContentLabel1.frame = layout.retweetContentRect

        picView1.frame = layout.picContainerRect
        let picLayout = picView1.collectionViewLayout as! UICollectionViewFlowLayout
        picLayout.itemSize = layout.picViewSize
    }
}
