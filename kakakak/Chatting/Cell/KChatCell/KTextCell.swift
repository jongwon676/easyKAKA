import UIKit
import Foundation
class KTextCell: KMessageCell,ChattingCellProtocol{
    
    static var reuseId = "KTextCell"
    
    let bubbleTextLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override func configure(message: Message, bgType: BgType) {
        self.message = message
        bubble.addSubview(bubbleTextLabel)
        super.configure(message: message, bgType: bgType)
        bubbleTextLabel.font = Style.messageLabelFont
        bubbleTextLabel.text = message.messageText
        bubbleTextLabel.font = Style.messageLabelFont
        bubbleTextLabel.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews(size: KTextCell.bubbleSize(message))
        bubbleTextLabel.frame.origin = CGPoint(x: Style.messageTextLeftInset, y: Style.messageTextRightInset)
    }
    
    
    class func bubbleSize(_ message: Message) -> CGSize{
        let maxWidth = UIScreen.main.bounds.width * 0.6
        let rect = message.messageText.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: Style.messageLabelFont], context: nil)
        return CGSize(width: rect.width + Style.messageTextLeftInset + Style.messageTextRightInset, height: rect.height + Style.messageTextTopInset + Style.messageTextBottomInset)
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
