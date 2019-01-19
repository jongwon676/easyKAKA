import UIKit
import SnapKit
class UserChattingBaseCell: BaseChatCell{

    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var profile: UIImageView = {
        let imageView = UIImageView()
        let width = 40
        imageView.layer.cornerRadius = CGFloat(width) / CGFloat(2)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.3863650262, green: 0.4467757344, blue: 0.4761275649, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var readLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9955037236, green: 0.9007681012, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
}
