import UIKit
class TextAnother: BaseChat,ChattingCellProtocol{
    static var reuseId = "textAnother"
  
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var bubble: UIView!
    @IBOutlet var timeAndReadLabel: TimeAndReadLabel!
    
    
    
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
        timeAndReadLabel.setUp(message: message)
        bubble.snp.updateConstraints { (mk) in
            if message.isFirstMessage{
               mk.top.equalTo(self.snp.top).offset(Style.firstMessageGap)
            }else{
                mk.top.equalTo(self.snp.top).offset(Style.moreThanFirstMessageGap)
            }
        }
    }
}
