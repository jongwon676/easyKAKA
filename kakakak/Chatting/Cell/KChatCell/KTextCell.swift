import UIKit
import Foundation
class KTextCell: KMessageCell,ChattingCellProtocol{
    
    static var reuseId = "KTextCell"
    var isMe = false
    let bubbleTextLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override func configure(message: Message, bgType: BgType) {
        self.message = message
        guard let owner = message.owner else { return }
        isMe = owner.isMe
        bubble.addSubview(bubbleTextLabel)
        super.configure(message: message, bgType: bgType)
        bubbleTextLabel.font = Style.messageLabelFont
        bubbleTextLabel.text = message.messageText
        bubbleTextLabel.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews(size: KTextCell.bubbleSize(message))
        bubbleTextLabel.frame.origin = CGPoint(x: Style.messageTextLeftInset, y: Style.messageTextTopInset)
    }
    
    
    class func bubbleSize(_
        
        message: Message) -> CGSize{
        let maxWidth = UIScreen.main.bounds.width * 0.6
        let rect = message.messageText.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: Style.messageLabelFont], context: nil)
        return CGSize(width: rect.width + Style.messageTextLeftInset + Style.messageTextRightInset, height: rect.height + Style.messageTextTopInset + Style.messageTextBottomInset)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let direction: DrawHelper.Direction  = isMe ? .right : .left
        let corner: CGPoint = direction == .left ? bubble.frame.origin : bubble.frame.rightTopCorner
        if self.message.isFirstMessage{
            let path = UIBezierPath()
            let points = DrawHelper.drawTail(dir: direction, cornerPoint: corner)
            path.move(to: points[0])
            path.addLine(to: points[1])
            path.addLine(to: points[2])
            path.addLine(to: points[3])
            path.close()
            bubble.backgroundColor?.setFill()
            path.fill()
        }        
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
