
import UIKit
class RecordMessageMe: BaseChat,ChattingCellProtocol{
    static var reuseId: String{
        return "recordMessageMe"
    }
    
    @IBOutlet var timeReadLabel: TimeAndReadLabel!
    @IBOutlet var failView: UIImageView!
    @IBOutlet var profile: ChatRadiusProfileView!
    @IBOutlet var playTimeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var second: NSLayoutConstraint!
    @IBOutlet var first: NSLayoutConstraint!
    func configure(message: Message) {
        
        self.backgroundColor = UIColor.clear
        self.containerView.backgroundColor = UIColor.clear
        profile.isHidden = !message.isFirstMessage
        nameLabel.isHidden = profile.isHidden
        failView.isHidden = !message.isFail
        timeReadLabel.isHidden = message.isFail
        first.isActive = message.isFirstMessage
        second.isActive = !message.isFirstMessage
        guard let owner = message.owner else { return }
        nameLabel.text = owner.name
        profile.image = UIImage.loadImageFromName(owner.profileImageUrl ?? "")
    }
    
    
}
