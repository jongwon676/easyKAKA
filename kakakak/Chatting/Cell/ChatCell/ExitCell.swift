
import UIKit
class ExitCell: BaseChat,ChattingCellProtocol{
    @IBOutlet var exitLabel: UILabel!
    static var reuseId: String{
        return "exit"
    }
    
    func configure(message: Message) {
        self.message = message
        self.backgroundColor = UIColor.clear
        exitLabel.text = message.messageText
    }
}
