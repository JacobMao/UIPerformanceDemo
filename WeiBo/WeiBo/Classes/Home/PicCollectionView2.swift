import UIKit
import SDWebImage
import Kingfisher

private let imageCache: NSCache<NSURL, UIImage> = {
    return NSCache<NSURL, UIImage>()
}()

class PicCollectionView2: UICollectionView {
    var picUrls : [URL] = [URL](){
        didSet{
            self.reloadData()
        }
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        register(PicCollectionViewCell2.self, forCellWithReuseIdentifier: "picCell")
        dataSource = self
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PicCollectionView2 : UICollectionViewDataSource , UICollectionViewDelegate{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return picUrls.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! PicCollectionViewCell2

        if cell.iconImageLayer.frame == CGRect.zero {
            cell.iconImageLayer.frame = CGRect(x: 0,
                                               y: 0,
                                               width: (collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width,
                                               height: (collectionViewLayout as! UICollectionViewFlowLayout).itemSize.height)
        }

        cell.picUrl = picUrls[indexPath.item]
        return cell
    }
}

class PicCollectionViewCell2: UICollectionViewCell {
    let iconImageLayer: CALayer
    private var imageOperation: SDWebImageOperation?

    override init(frame: CGRect) {
        iconImageLayer = CALayer()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        iconImageLayer.contentsScale = UIScreen.main.scale
        iconImageLayer.isOpaque = true
        iconImageLayer.backgroundColor = UIColor.white.cgColor
        CATransaction.commit()

        super.init(frame: frame)

        contentView.layer.addSublayer(iconImageLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        iconImageLayer = CALayer()

        super.init(coder: aDecoder)

        contentView.layer.addSublayer(iconImageLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if iconImageLayer.frame != self.contentView.bounds {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            iconImageLayer.frame = self.contentView.bounds
            CATransaction.commit()
        }
    }

    var picUrl : URL? {
        didSet{
            guard let url = picUrl else {  return  }

            imageOperation?.cancel()

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.iconImageLayer.contents = nil
            CATransaction.commit()

            if let image = imageCache.object(forKey: url as NSURL) {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                self.iconImageLayer.contents = image.cgImage
                CATransaction.commit()
                return
            }

            imageOperation = SDWebImageManager.shared().loadImage(with: url,
                                                 options: [],
                                                 progress: nil) { (image, _, _, _, finished, _) in
                                                    if !finished {
                                                        return
                                                    }

                                                    guard let i = image else {
                                                        return
                                                    }

                                                    let resizeFactor = self.contentView.bounds.size
                                                    let scaleFactor = self.iconImageLayer.contentsScale
                                                    DispatchQueue.global().async {
                                                        let resizedImage = i.kf.scaled(to: scaleFactor).kf.resize(to: resizeFactor)
                                                        DispatchQueue.main.async {
                                                            imageCache.setObject(resizedImage, forKey: url as NSURL)

                                                            if url != self.picUrl {
                                                                return
                                                            }
                                                            
                                                            CATransaction.begin()
                                                            CATransaction.setDisableActions(true)
                                                            self.iconImageLayer.contents = resizedImage.cgImage
                                                            CATransaction.commit()
                                                        }
                                                    }
            }
         }
    }
}
