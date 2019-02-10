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
    
    @IBOutlet var leading: NSLayoutConstraint!
    
    func moveConstraint(){
        guard let owner = message.owner else { return }
        leading.constant = editMode ? 30 : 0
        if message.isLastMessage{
            timeReadLabel.setUp(message: message)
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
}


