import UIKit
import SnapKit
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
    
    fileprivate func setupImage(){
        

        guard let image = messageImage.image else { return }
                
        updateConstraints()
        messageImage.layer.cornerRadius = 2
        
    }

    var mImage: UIImage?{
        didSet{
            messageImage.image = mImage
            setupImage()
        }
    }
    
    var lastWidth = -1
    var lastHeight = -1
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(message: Message, bgType: BgType) {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        failView.isHidden = !message.isFail
        self.message = message
        timeReadLabel.setUp(message: message, timeColor: bgType.chattingTimeColor)
        timeReadLabel.isHidden = false
        timeReadLabel.isHidden = !failView.isHidden
        
        mImage = UIImage.loadImageFromName(message.messageImageUrl)
        
        
        if lastWidth != message.imageWidth || lastHeight != message.imageHeight{
            lastWidth = message.imageWidth
            lastHeight = message.imageHeight
            messageImage.snp.remakeConstraints { (mk) in
                mk.width.equalTo(message.imageWidth)
                mk.height.equalTo(message.imageHeight)
            }
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
