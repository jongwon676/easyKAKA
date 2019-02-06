
import UIKit
class RecordMessageMe: UserChattingBaseMeCell,ChattingCellProtocol{
    static var reuseId: String{
        return "recordMessageMe"
    }
    
    
    
    
    
    @IBOutlet var playTimeLabel: UILabel!

    
    func configure(message: Message) {
        self.containerView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        profile.isHidden = !message.isFirstMessage
        nameLabel.isHidden = profile.isHidden
        
        timeReadLabel.isHidden = message.isFail
        
        guard let owner = message.owner else { return }
        timeReadLabel.setUp(message: message)
        nameLabel.text = owner.name
        profile.image = UIImage.loadImageFromName(owner.profileImageUrl ?? "")
        
        playTimeLabel.text = ""
        playTimeLabel.text! += String(message.duration / 60)
        let secondString = String(message.duration % 60)
        playTimeLabel.text! += secondString.count < 2 ? ":0" + secondString : ":" + secondString
    }
    
    
}
