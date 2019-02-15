import UIKit
import SnapKit
class ImageMe: UserChattingBaseMeCell,ChattingCellProtocol{
    
    var lastWidth = -1
    var lastHeight = -1
    
    func configure(message: Message, bgType: BgType) {
        self.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        self.message = message
        mImage = UIImage.loadImageFromName(message.messageImageUrl)
        
        timeReadLabel.setUp(message: message, timeColor: bgType.chattingTimeColor)
        
        if lastWidth != message.imageWidth || lastHeight != message.imageHeight{
            lastWidth = message.imageWidth
            lastHeight = message.imageHeight
            messageImage.snp.remakeConstraints { (mk) in
                mk.width.equalTo(message.imageWidth)
                mk.height.equalTo(message.imageHeight)
            }
        }
        
        moveConstraint()
    }

    static var reuseId = "imageMe"
    
    @IBOutlet var messageImage: UIImageView!
    
    
    
    
    fileprivate func setupImage(){
        messageImage.image = mImage
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
