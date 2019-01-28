import UIKit
import SnapKit
import RealmSwift

class UserEnterCell: BaseChatCell,ChattingCellProtocol{
    
    static var reuseId: String = Message.MessageType.enter.rawValue
    lazy var inviteLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.132842958, green: 0.1489416063, blue: 0.1573187113, alpha: 1)
        return label
    }()
    
    func configure(message: Message){
        
        let fromName = ""
        let toName = ""
        
        inviteLabel.text = "\(fromName)님이 \(toName)님을 초대했습니다."
        inviteLabel.sizeToFit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        let containerView = UIView()
        
//        self.addSubview(topView)
        self.addSubview(containerView)
        containerView.addSubview(inviteLabel)
        containerView.backgroundColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
        
        containerView.snp.makeConstraints { (mk) in
            mk.left.right.bottom.equalTo(self)
            mk.top.equalTo(self)
//            mk.top.equalTo(topView.snp.bottom)
            mk.height.equalTo(32)
        }
        
        inviteLabel.snp.makeConstraints { (mk) in
            mk.center.equalTo(containerView)
     
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
