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
        view.backgroundColor = #colorLiteral(red: 0.8980090533, green: 0.8980090533, blue: 0.8980090533, alpha: 1)
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var outerShadowView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7781470798, green: 0.7781470798, blue: 0.7781470798, alpha: 1)
        view.layer.masksToBounds = true
        return view
    }()
    lazy var nameBackgroudView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 0.5
        view.layer.borderColor  = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
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
        nameLabel.font = UIFont.systemFont(ofSize: 11)
        nameLabel.textAlignment = .center
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print(self.imageView.bounds.size)
        innerShadowView.layer.cornerRadius = innerShadowView.frame.height / 2.0
        outerShadowView.layer.cornerRadius = innerShadowView.frame.height / 2.0
        imageView.layer.cornerRadius = imageView.frame.height / 2.0
        
    }

    private struct StyleGuide{
        
        static let imageSize = 60
        static let shadowOffset = 5
        static let imageWidthToContainerViewWidth: CGFloat = 60.0 / 90.0
        static let innerShadowWidthToContainerViewWidth: CGFloat = 70.0 / 90.0
        static let outerShadowWidthToContainerViewWidth: CGFloat = 80.0 / 90.0
        static let innerShadowSize = StyleGuide.imageSize + StyleGuide.shadowOffset
        static let outerShadowSize = StyleGuide.imageSize + 2 * StyleGuide.shadowOffset
        static let imageWidthToNameBackgroundLabelWidth:CGFloat = 0.8
        static let imageHeightToNameBackgroundLabelHeight: CGFloat = 0.35
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        let attributes = layoutAttributes as! UserCollectionLayoutAttributes
        let percent: CGFloat = (1.0 - attributes.distToCenterRatio)
        nameBackgroudView.alpha = percent
        nameViewBottomConstraint?.update(offset: -1.0 * percent * 10)
        innerShadowView.alpha = percent
        outerShadowView.alpha = percent
    }
}



