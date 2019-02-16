import UIKit

class KBaseCell: UITableViewCell{
    
    var message: Message!
    
    lazy var containerView: UIView = {
       let view = UIView()
       self.addSubview(view)
       return view
    }()
    
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
        containerView.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        
        self.addSubview(checkBoxImage)
        self.addSubview(containerView)
        
        containerView.snp.makeConstraints { (mk) in
            mk.edges.equalTo(self)
        }
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
        self.addSubview(containerView)
        
        containerView.snp.makeConstraints { (mk) in
            mk.edges.equalTo(self)
        }
        checkBoxImage.image = UIImage(named: "unSelected")
        checkBoxImage.isHidden = !editMode
        checkBoxImage.snp.makeConstraints { (mk) in
            mk.centerY.equalTo(self)
            mk.width.height.equalTo(Style.checkBoxSize)
            mk.left.equalTo(self).offset(Style.checkBoxOffset)
        }
    }
    
}
