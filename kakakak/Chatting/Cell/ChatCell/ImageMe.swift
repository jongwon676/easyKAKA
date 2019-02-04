import UIKit
class ImageMe: BaseChat,ChattingCellProtocol{
    static var reuseId = "imageMe"
    
    @IBOutlet var profile: ChatRadiusProfileView!
    @IBOutlet var messageImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var failView: UIImageView!
    @IBOutlet var timeReadLabel: TimeAndReadLabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var leading: NSLayoutConstraint!
    
    @IBOutlet var first: NSLayoutConstraint!
    @IBOutlet var second: NSLayoutConstraint!
    @IBOutlet var bubble: CornerRadiusView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        first.isActive = true
        second.isActive = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(message: Message) {
        self.backgroundColor = UIColor.clear
        self.containerView.backgroundColor = UIColor.clear
        
        profile.isHidden = !message.isFirstMessage
        nameLabel.isHidden = profile.isHidden
        failView.isHidden = !message.isFail
        timeReadLabel.isHidden = message.isFail
        
        first.isActive =
            message.isFirstMessage
        second.isActive = !message.isFirstMessage
        leading.constant = editMode ? 30 : 0
        messageImage.image = UIImage.loadImageFromName(message.messageImageUrl)
        timeReadLabel.setUp(message: message)
    }
}
