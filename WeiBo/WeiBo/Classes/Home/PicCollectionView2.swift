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

        if cell.iconImageView.frame == CGRect.zero {
            cell.iconImageView.frame = CGRect(x: 0,
                                              y: 0,
                                              width: (collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width,
                                              height: (collectionViewLayout as! UICollectionViewFlowLayout).itemSize.height)
        }

        cell.picUrl = picUrls[indexPath.item]
        return cell
    }
}

class PicCollectionViewCell2: UICollectionViewCell {
    let iconImageView: UIImageView

    override init(frame: CGRect) {
        iconImageView = UIImageView()

        super.init(frame: frame)

        contentView.addSubview(iconImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        iconImageView = UIImageView()

        super.init(coder: aDecoder)

        contentView.addSubview(iconImageView)
    }

    var picUrl : URL? {
        didSet{
            guard let url = picUrl else {  return  }
            iconImageView.sd_setImage(with: url, placeholderImage: nil)
         }
    }
}
