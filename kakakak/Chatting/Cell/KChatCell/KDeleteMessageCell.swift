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
    
    
    override func configure(message: Message, bgType: BgType) {
        
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
