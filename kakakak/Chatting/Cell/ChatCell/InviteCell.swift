import UIKit
class InviteCell: BaseChat,ChattingCellProtocol{
    static var reuseId: String{
        return "invite"
    }
    
    @IBOutlet var inviteLabel: UILabel!
    
    func configure(message: Message) {
        self.message = message
        self.backgroundColor = UIColor.clear
        inviteLabel.text = message.messageText
    }
    
    
}
