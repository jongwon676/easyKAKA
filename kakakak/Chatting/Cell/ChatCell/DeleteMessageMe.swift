
import UIKit
import SnapKit
class DeleteMessageMe: BaseChat,ChattingCellProtocol {
    static var reuseId: String{
        return "deleteMessageMe"
    }

    @IBOutlet var profileConstraint: NSLayoutConstraint!
    @IBOutlet var second: NSLayoutConstraint!
    @IBOutlet var first: NSLayoutConstraint!
    @IBOutlet var profile: ChatRadiusProfileView!
    
    
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var deleteLabel: UILabel!
    
    @IBOutlet var timeReadLabel: TimeAndReadLabel!
    @IBOutlet var failView: UIImageView!
    @IBOutlet var warningView: UIImageView!
    @IBOutlet var bubble: UIView!
    
    @IBOutlet var leading: NSLayoutConstraint!
    @IBOutlet var container: UIView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(message: Message) {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.container.backgroundColor = UIColor.clear
        timeReadLabel.setUp(message: message)
        nameLabel.isHidden = profile.isHidden
        failView.isHidden = !message.isFail
        timeReadLabel.isHidden = message.isFail
        profile.isHidden = !message.isFirstMessage
        nameLabel.isHidden = profile.isHidden
        
        guard let owner = message.owner else { return }
        
        
        
        
        
        if message.isFirstMessage{
            NSLayoutConstraint.activate([first,profileConstraint])
            NSLayoutConstraint.deactivate([second])
            
            nameLabel.text = owner.name
            profile.image = UIImage.loadImageFromName(owner.profileImageUrl ?? "")
        }else{
            
            NSLayoutConstraint.activate([second])
            NSLayoutConstraint.deactivate([first,profileConstraint])
        }
        leading.constant = editMode ? 30 : 0
        updateFocusIfNeeded()
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profile.image = nil
        nameLabel.text = ""
    }
}
