import UIKit
import SnapKit

class UserCollectionCell: UICollectionViewCell {
    var nameViewBottomConstraint: Constraint?
    
    var containerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var innerShadowView:UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.05
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var outerShadowView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.alpha = 0.05
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var nameBackgroudView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.masksToBounds = true
        
        
        return view
    }()
    lazy var nameLabel:UILabel = {
       let label = UILabel()
        label.backgroundColor = UIColor.clear
        return label
    }()
    class var reuseId: String {
        return "UserCollectionCell"
    }
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        
        return imgView
    }()
    
    
    var user: User?{
        didSet{
            let img = UIImage.loadImageFromName((user?.profileImageUrl)!)!
            imageView.image = img
//            nameLabel.text = user?.name
            setupView()
        }
    }
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(containerView)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        containerView.addSubview(outerShadowView)
        containerView.addSubview(innerShadowView)
        containerView.addSubview(imageView)
        containerView.addSubview(nameBackgroudView)
        containerView.addSubview(nameLabel)
        
        
        imageView.snp.makeConstraints { (mk) in
            mk.center.equalTo(containerView)
            mk.width.height.equalTo(containerView.snp.width).multipliedBy(StyleGuide.imageWidthToContainerViewWidth)
            
        }
        innerShadowView.snp.makeConstraints { (mk) in
            mk.center.equalTo(containerView)
            mk.width.height.equalTo(containerView.snp.width).multipliedBy(StyleGuide.innerShadowWidthToContainerViewWidth)
        }
        outerShadowView.snp.makeConstraints { (mk) in
            mk.center.equalTo(containerView)
            mk.width.height.equalTo(containerView.snp.width).multipliedBy(StyleGuide.outerShadowWidthToContainerViewWidth)

        }
        nameBackgroudView.snp.makeConstraints { (mk) in
            mk.centerX.equalTo(containerView)
            nameViewBottomConstraint = mk.bottom.equalTo(containerView).constraint
            mk.width.equalTo(imageView.snp.width).multipliedBy(StyleGuide.imageWidthToNameBackgroundLabelWidth)
            mk.height.equalTo(imageView.snp.height).multipliedBy(StyleGuide.imageHeightToNameBackgroundLabelHeight)
        }

        nameLabel.snp.makeConstraints { (mk) in
            mk.edges.equalTo(nameBackgroudView).inset(UIEdgeInsets(top: 1.5, left: 1.5, bottom: 1.5, right: 1.5))
        }
        containerView.snp.makeConstraints { (mk) in
            mk.left.right.top.bottom.equalTo(self)
        }
        
        
        imageView.contentMode = .scaleAspectFill
        nameLabel.text = user?.name
        nameLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        nameLabel.textAlignment = .center
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        innerShadowView.layer.cornerRadius = innerShadowView.frame.height / 2.0
//        outerShadowView.layer.cornerRadius = innerShadowView.frame.height / 2.0
        
        innerShadowView.layer.cornerRadius = StyleGuide.innerShadowSize / 2
        outerShadowView.layer.cornerRadius = StyleGuide.outerShadowSize / 2
        imageView.layer.cornerRadius = StyleGuide.imageSize / 2
        
    }


    
    private struct StyleGuide{
        
        static let imageSize:CGFloat = 60
        
        static let imageWidthToContainerViewWidth: CGFloat = 60 / 80
        static let innerShadowWidthToContainerViewWidth: CGFloat = 70 / 80
        static let outerShadowWidthToContainerViewWidth: CGFloat = 80 / 80
        
        
        static let shadowOffset:CGFloat = 5
        static let innerShadowSize = StyleGuide.imageSize + 2  * StyleGuide.shadowOffset
        static let outerShadowSize = StyleGuide.imageSize + 4  * StyleGuide.shadowOffset
        
        
        static let imageWidthToNameBackgroundLabelWidth:CGFloat = 0.8
        static let imageHeightToNameBackgroundLabelHeight: CGFloat = 0.35
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        let attributes = layoutAttributes as! UserCollectionLayoutAttributes
        let percent: CGFloat = (1.0 - attributes.distToCenterRatio)
        nameBackgroudView.alpha = percent
        nameViewBottomConstraint?.update(offset: -1.0 * percent * 10)
        innerShadowView.alpha = percent * 0.05
        outerShadowView.alpha = percent * 0.05
        
    }
}



