import UIKit

class ImageEditCell: UITableViewCell,EditCellProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var message: Message?
    func getEditContent() -> (MessageProcessor.EditContent)? {
        guard let message = self.message else { return nil }
        if let newImage =  messageImageView.image?.writeImage(imgName: message.messageImageUrl){
            ProfileImageCacher.shared.addImageToCache(imgName: message.messageImageUrl, img: newImage)
            return MessageProcessor.EditContent.imageSize(CGSize(width: newImage.size.width, height: newImage.size.height))
        } else {
            return nil
        }
    }
    
    @IBOutlet var imageRatio: NSLayoutConstraint!
    @IBOutlet var messageImageView: UIImageView!
    
    fileprivate func setupImage(){
        messageImageView.image = messageImage
        imageRatio.isActive = false
        guard let image = messageImage else { return }
        let ratio = image.size.width / image.size.height
        imageRatio = NSLayoutConstraint(item: messageImageView, attribute: .width,
                                        relatedBy: .equal,
                                        toItem: messageImageView, attribute: .height,
                                        multiplier: ratio, constant: 0)
        imageRatio.isActive = true
        updateConstraints()
    }
    var messageImage: UIImage?{
        didSet{
           setupImage()
        }
    }
    
    
    func configure(msg: Message) {
        message = msg
        guard let image = UIImage.loadImageFromName(msg.messageImageUrl) else {
            return
        }
        
        messageImage = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
//    let gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.white.cgColor]
//        gradientLayer.locations = [0.5,1]
//        
//        self.layer.addSublayer(gradientLayer)
//        gradientLayer.frame = self.frame
    }
    
}
