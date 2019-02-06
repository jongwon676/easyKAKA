import UIKit
class ImageMe: UserChattingBaseMeCell,ChattingCellProtocol{
    static var reuseId = "imageMe"
    
    @IBOutlet var messageImage: UIImageView!
    
    
    
    

    @IBOutlet var bubble: CornerRadiusView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(message: Message) {
        self.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        self.message = message
        messageImage.image = UIImage.loadImageFromName(message.messageImageUrl)
        timeReadLabel.setUp(message: message)
        moveConstraint()
    }
}
