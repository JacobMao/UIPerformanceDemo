import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {
    var picUrls : [URL] = [URL](){
        didSet{
            self.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate = self
    }
}

extension PicCollectionView : UICollectionViewDataSource , UICollectionViewDelegate{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return picUrls.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = self.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! PicCollectionViewCell
        cell.picUrl = picUrls[indexPath.item]
        return cell
    }
}

class PicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!

    var picUrl : URL? {
        didSet{
            guard let url = picUrl else {  return  }
            iconImageView.sd_setImage(with: url, placeholderImage: nil)
         }
    }
}
