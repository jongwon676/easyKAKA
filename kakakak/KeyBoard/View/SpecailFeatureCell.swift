import UIKit
class SpecailFeatureCell: UICollectionViewCell{
    static var reuseId = "SpecailFeatureCell"

    var imageView: UIImageView = UIImageView()
    let imageContainer = UIView()
    var titleLabel: UILabel = UILabel()
    
    
    
    let containerLayer = CAShapeLayer()
    
    func configure(title: String, image: UIImage){
        self.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        self.addSubview(titleLabel)
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        imageView.image = image
        
        imageView.snp.makeConstraints { (mk) in
            
            mk.width.height.equalTo(imageContainer.snp.width).multipliedBy(0.7)
            mk.center.equalTo(imageContainer)
        }
        imageContainer.snp.makeConstraints { (mk) in
            mk.left.top.right.equalTo(self)
            mk.height.equalTo(self.snp.width)
        }
        titleLabel.snp.makeConstraints { (mk) in
            mk.centerX.equalTo(self)
            mk.bottom.equalTo(self)
        }        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageContainer.layer.insertSublayer(containerLayer, at: 0)
        imageContainer.layer.cornerRadius = 6
        imageContainer.layer.shadowColor = UIColor.gray.cgColor
        imageContainer.layer.shadowOpacity = 0.15
        imageContainer.layer.shadowRadius = 2
        imageContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        print(imageContainer.bounds)
        
        
        
        containerLayer.frame = imageContainer.bounds
        containerLayer.path = UIBezierPath(roundedRect: containerLayer.bounds, cornerRadius: 6).cgPath
        
        
        containerLayer.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        containerLayer.masksToBounds = true
    }
    
}
