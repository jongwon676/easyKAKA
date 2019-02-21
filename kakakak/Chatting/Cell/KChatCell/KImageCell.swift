import UIKit
class KImageCell: KMessageCell,ChattingCellProtocol{
    static var reuseId = "KImageCell"
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    let downloadIcon: UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "share")
        return imageView
    }()
    
    override func configure(message: Message, bgType: BgType) {
        self.message = message
        messageImageView.image = UIImage.loadImageFromName(message.messageImageUrl)
        bubble.addSubview(messageImageView)
        
        super.configure(message: message, bgType: bgType)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews(size: KImageCell.bubbleSize(message))
        messageImageView.frame = CGRect(x: 0, y: 0, width: CGFloat(message.imageWidth), height: CGFloat(message.imageHeight))
        
        guard let owner = message.owner else { return }
        
        let downloadIconSize = Style.downloadIconSize
        
        let downloadY:CGFloat = messageImageView.center.y - downloadIconSize.height / 2
        
        if owner.isMe {
            self.addSubview(downloadIcon)
            downloadIcon.frame.size = downloadIconSize
            
            let downloadX = bubble.frame.minX - Style.downloadIconToBubbleGap - downloadIconSize.width
            let downloadOrigin = CGPoint(x: downloadX, y: downloadY)
            downloadIcon.frame = CGRect(origin: downloadOrigin, size: downloadIconSize)
            
        }else{
            containerView.addSubview(downloadIcon)
            downloadIcon.frame.size = downloadIconSize
            
            let downloadX = bubble.frame.maxX + Style.downloadIconToBubbleGap
            let downloadOrigin = CGPoint(x: downloadX, y: downloadY)
            downloadIcon.frame = CGRect(origin: downloadOrigin, size: downloadIconSize)
        }
    }
    
    
    class func bubbleSize(_ message: Message) -> CGSize{
        let picWidth = message.imageWidth
        let picHeight = message.imageHeight
        return CGSize(width: picWidth, height: picHeight)
    }
    
    class func height(message: Message) -> CGFloat{
        let bubbleSize = self.bubbleSize(message)
        guard let owner = message.owner else { return 0 }
        let nameHeight = super.nameLabelHeight(message)
        if message.isFirstMessage{
            if owner.isMe {
                return bubbleSize.height + Style.firstMessageGap
            }else{
                return bubbleSize.height + nameHeight + Style.nameLabelBubbleGap + Style.firstMessageGap
            }
        }else{
            return bubbleSize.height  + Style.moreThanFirstMessageGap
        }
    }
    

}
