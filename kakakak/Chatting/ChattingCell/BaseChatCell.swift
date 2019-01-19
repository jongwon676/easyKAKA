import UIKit
import SnapKit
import RealmSwift

class BaseChatCell: UITableViewCell{
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var isFirst = false
    var isLast = false
    var incomming = false
    
}