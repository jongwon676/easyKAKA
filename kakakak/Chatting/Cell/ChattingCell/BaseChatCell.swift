import UIKit
import SnapKit
import RealmSwift

class BaseChatCell: UITableViewCell{
    var containerView: UIView = UIView()
    var editMode: Bool = false{
        didSet{
            checkBoxImage.isHidden = !editMode
        }
    }
    
    var checkBoxImage:UIImageView = {
        var imageView = UIImageView()
        
        return imageView
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(containerView)
        self.addSubview(checkBoxImage)
        
        checkBoxImage.image = UIImage(named: "unSelected")
        checkBoxImage.isHidden = !editMode
        checkBoxImage.snp.makeConstraints { (mk) in
            mk.centerY.equalTo(self)
            mk.width.height.equalTo(Style.checkBoxSize)
            mk.left.equalTo(self).offset(Style.checkBoxOffset)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    static func calc(message: Message) -> CGFloat{
//        switch message.type {
//        case .text: return TextCell.calcHeight(message: message)
//
//        default: return 40
//        }
//        return 40
//    }
}
