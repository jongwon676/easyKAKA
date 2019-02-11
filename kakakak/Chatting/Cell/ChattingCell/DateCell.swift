import UIKit
import SnapKit
import RealmSwift

class DateCell: BaseChatCell,ChattingCellProtocol{
    static var reuseId: String = Message.MessageType.date.rawValue
    
    lazy var leftSeparator: UIView = {
       let view = UIView()
        return view
    }()
    lazy var rightSeparator: UIView = {
       let view = UIView()
        return view
    }()
    
    let dateLabel = UILabel()
    
    func setSeperator(superview parent: UIView, dateLabel: UILabel,isLeft: Bool){
        let view = UIView()
        view.backgroundColor = UIColor.gray
        parent.addSubview(view)
        view.snp.makeConstraints { (mk) in
            mk.centerY.equalTo(parent)
            mk.height.equalTo(1)
            if isLeft{
                mk.right.equalTo(dateLabel.snp.left).offset(-8)
                mk.left.equalTo(self).offset(8)
            }else{
                mk.right.equalTo(self).offset(-8)
                mk.left.equalTo(dateLabel.snp.right).offset(8)
            }
        }
    }
    
    func configure(message: Message){
        
        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        let containerView = UIView()
        
        
        
        self.addSubview(dateLabel)
        self.addSubview(containerView)
        
        
        dateLabel.text = "2018년 4월 27일 금요일"
        dateLabel.sizeToFit()
        
        dateLabel.snp.makeConstraints { (mk) in
            mk.center.equalTo(containerView)
        }
        
        
        
        containerView.snp.makeConstraints { (mk) in
            mk.top.equalTo(self)
            mk.left.right.bottom.equalTo(self)
            mk.height.equalTo(30)
        }
        setSeperator(superview: containerView, dateLabel: dateLabel, isLeft: true)
        setSeperator(superview: containerView, dateLabel: dateLabel, isLeft: false)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
