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
    
    let maskImage = CALayer()
    
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
        
        
        maskImage.contents =  [ UIImage(named: "back")!] as Any
        
        

        profile.layer.cornerRadius = 0
        profile.layer.mask = maskImage
        profile.layer.masksToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        maskImage.frame = profile.frame
        let maskView = UIView(frame: CGRect(x: 64, y: 0, width: 128, height: 128))
        maskView.backgroundColor = .blue
        maskView.layer.cornerRadius = 64
        profile.mask = maskView
//        redView.mask = maskView
    }
    
}


