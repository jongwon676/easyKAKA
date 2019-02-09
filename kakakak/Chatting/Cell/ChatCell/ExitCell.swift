
import UIKit
class ExitCell: BaseChat,ChattingCellProtocol{
    @IBOutlet var exitLabel: UILabel!
    static var reuseId: String{
        return "exit"
    }
    
    func configure(message: Message) {
        self.message = message
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        exitLabel.text = message.messageText
    }
}
