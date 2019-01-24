import UIKit
import SnapKit
import RealmSwift

class BaseChatCell: UITableViewCell{
    var containerView: UIView = UIView()
    
    var isFirst = false
    var isLast = false
    var incomming = false
    
    static func calc(message: Message) -> CGFloat{
        switch message.type {
        case .text: return TextCell.calcHeight(message: message)
        
        default: return 40
        }
        return 40
    }
}
