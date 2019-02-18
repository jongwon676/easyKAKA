import UIKit

class KDateCell: KBaseCell,ChattingCellProtocol{
    static var reuseId: String = "KDateCell"
    
    let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let leftSep: UIView = {
       let view = UIView()
        return view
    }()
    let rightSep: UIView = {
        let view = UIView()
        return view
    }()
    
    func configure(message: Message, bgType: BgType) {
        self.message = message
        [dateLabel,leftSep,rightSep].forEach { (view) in
            contentView.addSubview(view)
        }
        dateLabel.text = Date.timeToStringDateLineVersion(date: message.sendDate)
        dateLabel.font = Style.dateFont
        dateLabel.sizeToFit()
        dateLabel.textColor = bgType.dateTextColor
        leftSep.backgroundColor = bgType.dateSeparatorColor
        rightSep.backgroundColor = bgType.dateSeparatorColor
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.center = self.contentView.center
        dateLabel.frame.origin.y = Style.dateLabelTopInset
        
        leftSep.center.y = dateLabel.center.y
        rightSep.center.y = dateLabel.center.y
        
        let paddings =  2 * (Style.dateSeperatorCornerGap + Style.dateSeperatorDateLabelGap)
        
        let sepWidth:CGFloat = (contentView.frame.width - paddings - dateLabel.frame.width) / 2
        let sepHeight: CGFloat = Style.dateSeperatorHeight
        leftSep.frame.origin.x = Style.dateSeperatorCornerGap
        rightSep.frame.origin.x = dateLabel.frame.maxX + Style.dateSeperatorDateLabelGap
        
        leftSep.frame.size = CGSize(width: sepWidth, height: sepHeight)
        rightSep.frame.size = CGSize(width: sepWidth, height: sepHeight)
        
    }
    
    class func height(message: Message) -> CGFloat{
        let maxWidth = UIScreen.main.bounds.width * 1.0
        let dateText = Date.timeToStringDateLineVersion(date: message.sendDate)
        
        let rect = dateText.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: Style.dateFont], context: nil)
        
        return rect.height + Style.dateLabelTopInset + Style.dateLabelBottomInset
    }
    
    
}
