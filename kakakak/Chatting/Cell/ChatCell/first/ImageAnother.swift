import UIKit
class ImageAnother: UserChattingBaseAnotherCell,ChattingCellProtocol{
    
    
    
    
    static var reuseId: String
    {
        return "imageAnother"
    }
    
    
    @IBOutlet var imageRatio: NSLayoutConstraint!
    
    @IBOutlet var messageImage: UIImageView!
    @IBOutlet var failView: UIImageView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    fileprivate func setupImage(){
        
        imageRatio.isActive = false
        
        guard let image = messageImage else { return }
        let ratio = image.size.width / image.size.height
        imageRatio = NSLayoutConstraint(item: messageImage, attribute: .width,
                                        relatedBy: .equal,
                                        toItem: messageImage, attribute: .height,
                                        multiplier: ratio, constant: 0)
        imageRatio.isActive = true
        updateConstraints()
    }
    
    
    
    var mImage: UIImage?{
        didSet{
            setupImage()
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(message: Message, bgType: BgType) {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        failView.isHidden = !message.isFail
        self.message = message
        if message.isLastMessage{
            timeReadLabel.isHidden = false
            timeReadLabel.isHidden = !failView.isHidden
        }else{
            timeReadLabel.isHidden = true
        }
        mImage = UIImage.loadImageFromName(message.messageImageUrl)
        
        timeReadLabel.setUp(message: message, timeColor: bgType.getNavUserCountColor())
    }
}
