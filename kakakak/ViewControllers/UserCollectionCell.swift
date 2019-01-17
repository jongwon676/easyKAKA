import UIKit


class UserCollectionCell: UICollectionViewCell {
    
    
    
    var user: User?{
        didSet{
            imageView.layer.borderColor = (user?.isSelected)! ? UIColor.red.cgColor : UIColor.clear.cgColor
            print(user?.isSelected)
            imageView.layer.borderWidth = 3
            let img = UIImage.loadImageFromName((user?.profileImageUrl)!)!
            imageView.image = img
        }
    }
    
    class var reuseId: String {
        return "UserCollectionCell"
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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
}
