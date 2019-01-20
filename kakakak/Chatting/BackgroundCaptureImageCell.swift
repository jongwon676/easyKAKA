import UIKit
import SnapKit
class BackgroundCaptureImageCell: UICollectionViewCell{
    static var reuseId = "BackgroundCaptureImageCell"
    var image: UIImage?{
        didSet{
            if image == nil{
                 // default image 삽입
            }else{
                backgroundImage.image = image
            }
        }
    }
    lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (mk) in
            mk.left.right.bottom.top.equalTo(self)
        }
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
