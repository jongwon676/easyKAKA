import UIKit
import SnapKit
import RealmSwift

class BaseChat: UITableViewCell{
    var message: Message!{
        didSet{
            if message.isFirstMessage{
                setNeedsDisplay()
            }
        }
    }
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
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear

        
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
        super.init(coder: aDecoder)
        self.addSubview(checkBoxImage)
        
        checkBoxImage.image = UIImage(named: "unSelected")
        checkBoxImage.isHidden = !editMode
        checkBoxImage.snp.makeConstraints { (mk) in
            mk.centerY.equalTo(self)
            mk.width.height.equalTo(Style.checkBoxSize)
            mk.left.equalTo(self).offset(Style.checkBoxOffset)
        }
    }
}
