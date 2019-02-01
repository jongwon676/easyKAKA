import UIKit
class InviteCell: BaseChat,ChattingCellProtocol{
    static var reuseId: String{
        return "invite"
    }
    
    @IBOutlet var inviteLabel: UILabel!
    
    func configure(message: Message) {
        self.backgroundColor = UIColor.clear
    }
    
    
}
