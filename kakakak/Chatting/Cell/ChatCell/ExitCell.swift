import UIKit
class ExitCell: BaseChat,ChattingCellProtocol{
    static var reuseId: String{
        return "exit"
    }
    
    @IBOutlet var exitLabel: UILabel!
    func configure(message: Message) {
        self.backgroundColor = UIColor.clear
    }
    
    
}
