
import UIKit
import SnapKit
class DeleteMessageMe: UserChattingBaseMeCell,ChattingCellProtocol {
    static var reuseId: String{
        return "deleteMessageMe"
    }

    @IBOutlet var deleteLabel: UILabel!
    
    
    
    @IBOutlet var warningView: UIImageView!
    @IBOutlet var bubble: UIView!
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func configure(message: Message) {
        self.message = message
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        moveConstraint()
        updateFocusIfNeeded()
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profile.image = nil
        nameLabel.text = ""
    }
}
