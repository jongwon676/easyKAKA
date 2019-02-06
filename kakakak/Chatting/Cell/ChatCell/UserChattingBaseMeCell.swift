import UIKit
import SnapKit
class UserChattingBaseMeCell: BaseChat{
    //
    @IBOutlet var profile: ChatRadiusProfileView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeReadLabel: TimeAndReadLabel!
    @IBOutlet var containerView: UIView!{
        didSet{
            containerView.backgroundColor = UIColor.black
        }
    }
    
    @IBOutlet var leading: NSLayoutConstraint!
    func moveConstraint(){
        leading.constant = editMode ? 30 : 0
    }
}


