import UIKit

class ExitCell: BaseChat,ChattingCellProtocol{
    @IBOutlet var containerView: UIView!
    func configure(message: Message, bgType: BgType) {
        self.message = message
        self.backgroundColor = UIColor.clear
        containerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        
        self.contentView.backgroundColor = UIColor.clear
        exitLabel.text = message.messageText
    }

    @IBOutlet var exitLabel: UILabel!
    static var reuseId: String{
        return "exit"
    }

}
