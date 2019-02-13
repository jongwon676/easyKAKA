import UIKit
import SnapKit
class UserChattingBaseMeCell: BaseChat{
    //
    @IBOutlet var profile: ChatRadiusProfileView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeReadLabel: TimeAndReadLabel!{
        didSet{
            timeReadLabel.text = ""
        }
    }
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
        timeReadLabel.text = ""
        leading.constant = editMode ? 30 : 0
        
        if let bgType = self.bgType{
            timeReadLabel.setUp(message: message, timeColor: bgType.chattingTimeColor)
        }
        if message.isFirstMessage{
           
            let imgName = owner.profileImageUrl ?? ""
            
            if let img = ProfileImageCacher.shared.requestImage(imgName: imgName){
                profile.image = img
            }else{
                profile.image = UIImage.loadImageFromName(imgName)
                ProfileImageCacher.shared.addImageToCache(imgName: imgName, img: profile.image ?? UIImage())
            }

            profile.isHidden = false
            nameLabel.isHidden = false
        }else{
            nameLabel.text = owner.name
            profile.isHidden = true
            nameLabel.isHidden = true
        }
        self.nameLabel.text = owner.name
        self.nameLabel.textColor = bgType?.userNameColor
        
        
        

        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        maskImageView.frame = profile.bounds
        profile.mask = maskImageView
        profile.layer.cornerRadius = 0
        
        profile.layer.masksToBounds = true
    }
    
}


