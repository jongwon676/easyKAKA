import UIKit
import SnapKit
import RealmSwift

class UserExitCell: BaseChatCell{
    static var reuseId = "UserExitCell"
    
    
    
    lazy var exitLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.132842958, green: 0.1489416063, blue: 0.1573187113, alpha: 1)
        label.numberOfLines = 2
        return label
    }()
    
    func configure(message: Message){
        
        let exitName = message.owner?.name
        let attrText =  NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        attrText.append(NSAttributedString(string: "\(exitName!)님이 나갔습니다.\n", attributes: [NSAttributedString.Key.paragraphStyle:paragraphStyle]))
        attrText.append(NSAttributedString(string: "채팅방으로 초대하기", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,NSAttributedString.Key.paragraphStyle: paragraphStyle ]))
        exitLabel.attributedText = attrText
        exitLabel.sizeToFit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        let containerView = UIView()
        
//        self.addSubview(topView)
        self.addSubview(containerView)
        containerView.addSubview(exitLabel)
        
        
        containerView.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
        
        containerView.snp.makeConstraints { (mk) in
            mk.left.right.bottom.equalTo(self)
//            mk.top.equalTo(topView.snp.bottom)
            mk.height.equalTo(52)
        }
    
        exitLabel.snp.makeConstraints { (mk) in
            mk.center.equalTo(containerView)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
