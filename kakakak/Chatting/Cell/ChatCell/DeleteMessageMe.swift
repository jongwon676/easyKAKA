
import UIKit

class DeleteMessageMe: BaseChat,ChattingCellProtocol {
    static var reuseId: String{
        return "deleteMessageMe"
    }

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
        profile.isHidden = !message.isFirstMessage
        nameLabel.isHidden = profile.isHidden
        failView.isHidden = !message.isFail
        timeReadLabel.isHidden = message.isFail
        first.isActive = message.isFirstMessage
        second.isActive = !message.isFirstMessage
        guard let owner = message.owner else { return }
        profile.image = UIImage.loadImageFromName(owner.profileImageUrl ?? "")
        nameLabel.text = owner.name
        
        leading.constant = editMode ? 30 : 0
    }
}
