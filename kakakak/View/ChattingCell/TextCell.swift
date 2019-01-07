import UIKit
import SnapKit
import RealmSwift

class TextCell: UserChattingBaseCell{
    
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.2655298114, green: 0.3016560972, blue: 0.3267259598, alpha: 1)
        return label
    }()
    
    lazy var bubbleView: UIView = {
        let bubble = UIView()
        bubble.layer.cornerRadius = 5
        bubble.layer.masksToBounds = true
        return bubble
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

