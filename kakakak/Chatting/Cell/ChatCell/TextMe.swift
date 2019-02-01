import UIKit
class TextMe: BaseChat,ChattingCellProtocol{
    static var reuseId = "textMe"
    
    
    //
    @IBOutlet var profile: ChatRadiusProfileView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bubble: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var failView: UIImageView!
    @IBOutlet var timeReadLabel: TimeAndReadLabel!
    
    @IBOutlet var messageNameLabelGap: NSLayoutConstraint!
    
    @IBOutlet var messageCellGap: NSLayoutConstraint!
    @IBOutlet var containerView: UIView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(message: Message){
    
        self.backgroundColor = UIColor.clear
        self.containerView.backgroundColor = UIColor.clear
        profile.isHidden = !message.isFirstMessage
        nameLabel.isHidden = profile.isHidden
        failView.isHidden = !message.isFail
        timeReadLabel.isHidden = message.isFail
        timeReadLabel.setUp(message: message)
        messageLabel.text = message.messageText
            if message.isFirstMessage{
               messageNameLabelGap.isActive = true
                messageCellGap.isActive = false
            }else{
                messageCellGap.isActive = true
                messageNameLabelGap.isActive = false
                
            }
        
    }
}
