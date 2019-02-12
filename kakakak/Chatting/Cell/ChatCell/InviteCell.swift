import UIKit
class InviteCell: BaseChat,ChattingCellProtocol{
    
    @IBOutlet var containerView: UIView!
    func configure(message: Message, bgType: BgType) {
        self.message = message
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        containerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)

        
        inviteLabel.text = message.messageText
    }
    
    
    
    static var reuseId: String{
        return "invite"
    }
    @IBOutlet var inviteLabel: UILabel!
    
}
