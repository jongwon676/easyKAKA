import UIKit
class InviteCell: BaseChat,ChattingCellProtocol{
    static var reuseId: String{
        return "invite"
    }
    @IBOutlet var inviteLabel: UILabel!
    func configure(message: Message) {
        self.message = message
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        
        
        inviteLabel.text = message.messageText
        
    }
}
