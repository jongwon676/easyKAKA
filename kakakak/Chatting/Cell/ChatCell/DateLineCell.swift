import UIKit
class DateLineCell: BaseChat,ChattingCellProtocol{
    static var reuseId: String{
        return  "dateLine"
    }
    @IBOutlet var bgView: UIView!
    @IBOutlet var dateLabel: UILabel!
    
    func configure(message: Message) {
        self.message = message
        self.backgroundColor = UIColor.clear
        self.bgView.backgroundColor = UIColor.clear
        dateLabel.text = Date.timeToStringDateLineVersion(date: message.sendDate)
        
    }
}
