import UIKit

class ImageCell: UICollectionViewCell {
    
    var user: User?{
        didSet{
            imageView.layer.borderColor = (user?.isSelected)! ? UIColor.red.cgColor : UIColor.clear.cgColor
            let img = UIImage.loadImageFromName((user?.profileImageUrl)!)!
            imageView.image = img
        }
    }
    
    class var reuseIdentifier: String {
        return "ImageCell"
    }
    
    let imageView: UIImageView = {
       let imgView = UIImageView()
        imgView.layer.borderColor = UIColor.red.cgColor
        imgView.layer.borderWidth = 1
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
}
