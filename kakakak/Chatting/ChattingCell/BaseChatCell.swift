import UIKit
import SnapKit
import RealmSwift

class BaseChatCell: UITableViewCell{
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        self.addSubview(view)
        return view
    }()
    
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
