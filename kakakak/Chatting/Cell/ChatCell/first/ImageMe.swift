import UIKit
class ImageMe: UserChattingBaseMeCell,ChattingCellProtocol{
    func configure(message: Message, bgType: BgType) {
        self.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        self.message = message
        mImage = UIImage.loadImageFromName(message.messageImageUrl)
        
        timeReadLabel.setUp(message: message, timeColor: bgType.getNavUserCountColor())
        moveConstraint()
    }

    static var reuseId = "imageMe"
    
    @IBOutlet var messageImage: UIImageView!
    
    @IBOutlet var imageRatio: NSLayoutConstraint!
    
    
    fileprivate func setupImage(){
        messageImage.image = mImage
        imageRatio.isActive = false
        guard let image = messageImage.image else { return }
        let ratio = image.size.width / image.size.height
        imageRatio = NSLayoutConstraint(item: messageImage, attribute: .width,
                                        relatedBy: .equal,
                                        toItem: messageImage, attribute: .height,
                                        multiplier: ratio, constant: 0)
        imageRatio.isActive = true
        messageImage.layer.cornerRadius = 2
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
    override func layoutSubviews() {
        super.layoutSubviews()

        
    }
    
}
