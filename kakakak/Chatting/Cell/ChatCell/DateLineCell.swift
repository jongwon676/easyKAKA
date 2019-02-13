import UIKit
class DateLineCell: BaseChat,ChattingCellProtocol{
    func configure(message: Message, bgType: BgType) {
        self.message = message
        self.backgroundColor = UIColor.clear
        self.bgView.backgroundColor = UIColor.clear
        dateLabel.text = Date.timeToStringDateLineVersion(date: message.sendDate)
        dateLabel.textColor = bgType.dateTextColor
        leftSep.backgroundColor = bgType.dateSeparatorColor
        rightSep.backgroundColor = bgType.getNavUserCountColor()
    }
    
    @IBOutlet var leftSep: UIView!
    @IBOutlet var rightSep: UIView!
    

    
    static var reuseId: String{
        return  "dateLine"
    }
    @IBOutlet var bgView: UIView!
    @IBOutlet var dateLabel: UILabel!
 
}
