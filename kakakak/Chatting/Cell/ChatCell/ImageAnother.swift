import UIKit
class ImageAnother: BaseChat,ChattingCellProtocol{
    static var reuseId: String
    {
        return "imageAnother"
    }
    
    @IBOutlet var timeReadLabel: TimeAndReadLabel!
    @IBOutlet var bubbleGap: NSLayoutConstraint!
    @IBOutlet var messageImage: UIImageView!
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configure(message: Message){
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        timeReadLabel.isHidden = message.isFail
        if message.isFirstMessage {
            bubbleGap.constant = Style.firstMessageGap
//            setNeedsUpdateConstraints()
            
        }else{
            bubbleGap.constant = Style.moreThanFirstMessageGap
//            setNeedsUpdateConstraints()
        }
        messageImage.image = UIImage.loadImageFromName(message.messageImageUrl ?? "")
        timeReadLabel.setUp(message: message)
    }
}
