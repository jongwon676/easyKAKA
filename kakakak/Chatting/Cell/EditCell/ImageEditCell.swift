import UIKit
import SnapKit


class ImageEditCell: UITableViewCell,EditCellProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var message: Message?
    weak var delegate: TableViewHeightProtocol?
    func getEditContent() -> (MessageProcessor.EditContent)? {
        guard let message = self.message else { return nil }
        if let newImage =  messageImageView.image?.writeImage(imgName: message.messageImageUrl){
            ProfileImageCacher.shared.addImageToCache(imgName: message.messageImageUrl, img: newImage)
            return MessageProcessor.EditContent.imageSize(CGSize(width: newImage.size.width, height: newImage.size.height))
        } else {
            return nil
        }
    }
    
    
    let messageImageView = UIImageView()
    
    
    
    @IBOutlet var editButton: UIButton!
    var realEditButton = UIButton(type: .system)
    fileprivate func setupImage(){
        self.addSubview(messageImageView)
        self.addSubview(editButton)
        
        editButton.setImage( #imageLiteral(resourceName: "imageEdit").withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        messageImageView.image = messageImage
        
        guard let image = messageImage else { return }
        let maxWidth: CGFloat = UIScreen.main.bounds.width * 0.6
        let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.5
        let newSize = image.getModifyImageSize(width: maxWidth, height: maxHeight)
        messageImageView.snp.removeConstraints()
        messageImageView.snp.remakeConstraints { (mk) in
            mk.top.equalTo(self).offset(8)
            mk.bottom.equalTo(self).inset(8)
            mk.center.equalTo(self)
            mk.width.equalTo(newSize.width)
            mk.height.equalTo(newSize.height)
            
        }
        
        editButton.snp.remakeConstraints { (mk) in

            mk.width.height.equalTo(48)
            mk.trailing.equalTo(messageImageView.snp.trailing).inset(10)
            mk.bottom.equalTo(messageImageView.snp.bottom).inset(10)
        }
        
        delegate?.needsRowHeightReCalcualte()
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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
