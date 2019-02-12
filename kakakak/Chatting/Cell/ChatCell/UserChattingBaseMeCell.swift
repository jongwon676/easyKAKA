import UIKit
import SnapKit
class UserChattingBaseMeCell: BaseChat{
    //
    @IBOutlet var profile: ChatRadiusProfileView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeReadLabel: TimeAndReadLabel!
    @IBOutlet var containerView: UIView!{
        didSet{
            containerView.backgroundColor = UIColor.black
        }
    }
    
    
    lazy var maskImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "mask")
        return imageView
    }()
    
    @IBOutlet var leading: NSLayoutConstraint!
    
    func moveConstraint(){
        guard let owner = message.owner else { return }
        leading.constant = editMode ? 30 : 0
        if message.isLastMessage{
            if let bgType = self.bgType{
                timeReadLabel.setUp(message: message, timeColor: bgType.getNavUserCountColor())
            }
            timeReadLabel.isHidden = false            
        }else{
            timeReadLabel.isHidden = true
        }
        if message.isFirstMessage{
            profile.image = UIImage.loadImageFromName(owner.profileImageUrl ?? "")
            profile.isHidden = false
            nameLabel.isHidden = false
        }else{
            nameLabel.text = owner.name
            profile.isHidden = true
            nameLabel.isHidden = true
        }
        self.nameLabel.text = owner.name
        
        
        
        

        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        maskImageView.frame = profile.bounds
        profile.mask = maskImageView
        profile.layer.cornerRadius = 0
        
        profile.layer.masksToBounds = true
    }
    
}


