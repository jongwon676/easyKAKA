import UIKit
class ImageAnother: UserChattingBaseAnotherCell,ChattingCellProtocol{
    static var reuseId: String
    {
        return "imageAnother"
    }
    
    
    
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
        messageImage.image = UIImage.loadImageFromName(message.messageImageUrl ?? "")
        timeReadLabel.setUp(message: message)
    }
}
