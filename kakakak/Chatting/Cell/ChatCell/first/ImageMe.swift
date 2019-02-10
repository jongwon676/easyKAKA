import UIKit
class ImageMe: UserChattingBaseMeCell,ChattingCellProtocol{
    static var reuseId = "imageMe"
    
    @IBOutlet var messageImage: UIImageView!
    
    @IBOutlet var imageRatio: NSLayoutConstraint!
    
    
    fileprivate func setupImage(){
        messageImage.image = mImage
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
        mImage = UIImage.loadImageFromName(message.messageImageUrl)
        timeReadLabel.setUp(message: message)
        moveConstraint()
    }
}
