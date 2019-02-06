import UIKit
class ImageAnother: UserChattingBaseAnotherCell,ChattingCellProtocol{
    static var reuseId: String
    {
        return "imageAnother"
    }
    
    
    
    @IBOutlet var messageImage: UIImageView!
    @IBOutlet var failView: UIImageView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configure(message: Message){
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        failView.isHidden = !message.isFail
        self.message = message
        if message.isLastMessage{
            timeReadLabel.setUp(message: message)
            timeReadLabel.isHidden = false
            timeReadLabel.isHidden = !failView.isHidden
        }else{
            timeReadLabel.isHidden = true
        }
        messageImage.image = UIImage.loadImageFromName(message.messageImageUrl)
        timeReadLabel.setUp(message: message)
    }
}
