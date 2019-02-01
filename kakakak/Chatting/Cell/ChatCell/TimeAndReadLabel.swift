import UIKit
class TimeAndReadLabel: UILabel{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setUp(message: Message){
        self.numberOfLines = 0
        var shadow = NSShadow()
        shadow.shadowColor = #colorLiteral(red: 0.5343024731, green: 0.6267417073, blue: 0.6852725148, alpha: 1)
        shadow.shadowOffset = CGSize(width: 0.5, height: 0.5)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        guard let owner = message.owner else { return }
        
        paragraphStyle.alignment = owner.isMe ? .left : .right
        paragraphStyle.lineSpacing = 1
        let readAtrributes: [NSAttributedString.Key: Any] = [
            .font: Style.readLabelFont,
            .foregroundColor: Style.readLabelColor,
            .shadow: shadow,
            .paragraphStyle: paragraphStyle
        ]
        let readString = NSAttributedString(string: String(message.noReadUser.count) + "\n" , attributes: readAtrributes)
//            let readString = NSAttributedString(string: String(3) + "\n" , attributes: readAtrributes)
        shadow = NSShadow()
        shadow.shadowColor = UIColor.clear
        let timeAttributes:  [NSAttributedString.Key: Any] = [
            .font: Style.timeLabelFont,
            .foregroundColor: Style.timeLabelColor,
            .paragraphStyle: paragraphStyle,
            .shadow: shadow
        ]
        let timeString = NSAttributedString(string: Date.timeToStringMinuteVersion(date: message.sendDate), attributes: timeAttributes)
        
        let attrString = NSMutableAttributedString()
        if message.noReadUser.count > 0 {
            attrString.append(readString)
        }
        if message.isLastMessage{
            attrString.append(timeString)
        }
        

        self.attributedText = attrString
        
        self.sizeToFit()
    }
}
