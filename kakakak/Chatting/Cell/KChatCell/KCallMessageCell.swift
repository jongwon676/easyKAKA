import UIKit
class KCallMessageCell: KMessageCell,ChattingCellProtocol{
    static var reuseId: String = "KCallMessageCell"
    let callMessageLabel = UILabel()
    let callImageView = UIImageView()
    
    override func configure(message: Message, bgType: BgType) {
        self.message = message
        let callImageAndTitle: (title: String, image: UIImage) = message.getTitleAndCallImage()
        super.configure(message: message, bgType: bgType)
        callMessageLabel.font = Style.callMessageFont
        callMessageLabel.text = callImageAndTitle.title
        callImageView.image = callImageAndTitle.image
        callMessageLabel.sizeToFit()
        
        bubble.addSubview(callMessageLabel)
        bubble.addSubview(callImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews(size: KCallMessageCell.bubbleSize(message))
        
        callImageView.frame.size = Style.callImageSize
        
        
        callMessageLabel.center = bubble.center
        callMessageLabel.center.y -= bubble.frame.origin.y
        callMessageLabel.frame.origin.x = callImageView.frame.maxX + Style.callImageLabelGap
        
        
        callImageView.center = bubble.center
        callImageView.center.y -= bubble.frame.origin.y
        callImageView.frame.origin.x = Style.callImageLeftGap
        
        
        
        
    }
    
    
    class func bubbleSize(_ message: Message) -> CGSize{
        let maxWidth = UIScreen.main.bounds.width * 1.0
        
        let callImageAndTitle: (title: String, image: UIImage) = message.getTitleAndCallImage()
        let callText = callImageAndTitle.title
        let rect = callText.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: Style.callMessageFont], context: nil)
        
        let width = Style.callImageLeftGap  + Style.callImageSize.width + Style.callImageLabelGap + Style.callLabelRightGap + rect.width
        
        let height = Style.callBubbleHeight
        
        return CGSize(width: width, height: height)
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
