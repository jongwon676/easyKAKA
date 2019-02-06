import UIKit
class TextAnother: UserChattingBaseAnotherCell,ChattingCellProtocol{
    static var reuseId = "textAnother"
  
    @IBOutlet var messageLabel: UILabel!
    
    
    @IBOutlet var failView: UIImageView!
    
    
    @IBOutlet var bubble: CornerRadiusView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(message: Message){
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.bubble.backgroundColor = Style.rightBubbleColor
        messageLabel.text = message.messageText
        failView.isHidden = !message.isFail
        if message.isLastMessage{

            timeReadLabel.setUp(message: message)
            timeReadLabel.isHidden = false
            timeReadLabel.isHidden = !failView.isHidden
        }else{
            timeReadLabel.isHidden = true
        }
    }
}
