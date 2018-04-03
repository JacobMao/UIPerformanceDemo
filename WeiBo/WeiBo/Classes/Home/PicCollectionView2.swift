import UIKit
import SDWebImage

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

        super.init(frame: frame)

        contentView.layer.addSublayer(iconImageLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        iconImageLayer = CALayer()

        super.init(coder: aDecoder)

        contentView.layer.addSublayer(iconImageLayer)
    }

    var picUrl : URL? {
        didSet{
            guard let url = picUrl else {  return  }

            imageOperation?.cancel()

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.iconImageLayer.contents = nil
            CATransaction.commit()

            imageOperation = SDWebImageManager.shared().loadImage(with: url,
                                                                  options: [],
                                                                  progress: nil) { (image, _, _, _, _, _) in
                                                                    CATransaction.begin()
                                                                    CATransaction.setDisableActions(true)
                                                                    self.iconImageLayer.contents = image?.cgImage
                                                                    CATransaction.commit()
            }
         }
    }
}
