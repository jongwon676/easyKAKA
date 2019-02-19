import UIKit
import Foundation
class KDeleteMessageCell: KMessageCell,ChattingCellProtocol{
    
    static var reuseId = "KDeleteMessageCell"
    
  
    let deleteLabel: UILabel = {
        let label = UILabel()
        label.font = Style.deleteLabelFont
        return label
    }()
    let warningImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "warning")
        imageView.frame.size = Style.warningViewSize
        return imageView
    }()
    
    var isMe = false
    override func configure(message: Message, bgType: BgType) {
        guard let owner = message.owner else { return }
        isMe = owner.isMe
        
        self.message = message
        deleteLabel.text = Style.deleteText
        deleteLabel.sizeToFit()
        super.configure(message: message, bgType: bgType)
        bubble.addSubview(deleteLabel)
        bubble.addSubview(warningImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews(size: KDeleteMessageCell.bubbleSize(message))
        
        
        [deleteLabel,warningImageView].forEach { (view) in
            view.center = bubble.center
            view.center.y -= bubble.frame.origin.y
        }
        warningImageView.frame.origin.x = Style.warningToLeftGap
        deleteLabel.frame.origin.x = warningImageView.frame.maxX + Style.warningViewToDeleteLabelGap
        
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

    
    
    class func bubbleSize(_ message: Message) -> CGSize{
        
        
        let maxWidth = UIScreen.main.bounds.width * 1.0
        
        let rect = Style.deleteText.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: Style.deleteLabelFont], context: nil)
        
        let width = Style.warningViewSize.width + Style.warningToLeftGap + Style.warningViewToDeleteLabelGap + rect.width +  Style.deleteLabelRightInset
        
        let height = rect.height + Style.deleteLabelTopInset + Style.deleteLabelBottomInset
        
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
