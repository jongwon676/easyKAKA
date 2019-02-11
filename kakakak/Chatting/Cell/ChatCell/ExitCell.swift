
import UIKit
class ExitCell: BaseChat,ChattingCellProtocol{
    func configure(message: Message, bgType: BgType) {
        self.message = message
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        exitLabel.text = message.messageText
    }
    
    
    
    @IBOutlet var exitLabel: UILabel!
    static var reuseId: String{
        return "exit"
    }

}
