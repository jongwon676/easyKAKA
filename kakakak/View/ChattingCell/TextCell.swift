import UIKit
import SnapKit
import RealmSwift

class TextCell: UserChattingBaseCell{

    static var reuseId: String = "TextCell"
    
    lazy var commonViews:[UIView] = [topView,bubbleView,messageLabel]
    lazy var leftFirstViews: [UIView] = [nameLabel,profile]
    lazy var rightFirstViews: [UIView] = []
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.2655298114, green: 0.3016560972, blue: 0.3267259598, alpha: 1)
        label.numberOfLines = 0
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

    var subs: [UIView]{
        get{
            let return_views = commonViews + ((incomming && isFirst) ? leftFirstViews : [])
            return return_views
        }
    }
    
    func configure(message: Message){
        clear()
        profile.image = UIImage.loadImageFromName(message.owner!.profileImageUrl!)!
        messageLabel.text = message.messageText
        timeLabel.text = Date.timeToString(date: message.sendDate)
        readLabel.text = String(message.noReadUser.count)
            
        bubbleView.backgroundColor = incomming ? #colorLiteral(red: 0.9996673465, green: 0.8927946687, blue: 0.005554047879, alpha: 1) : #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1)
        
        subs.forEach { (sub) in
            self.addSubview(sub)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = incomming ? .leading : .trailing
        self.addSubview(stackView)
        
        
        topView.snp.remakeConstraints { (mk) in
            mk.left.right.top.equalTo(self)
            mk.height.equalTo( ( isFirst ? Style.firstMessageGap : 0 ) )
        }
        
        stackView.snp.remakeConstraints { (mk) in
            if incomming { mk.left.equalTo(bubbleView.snp.right).offset(7) }
            else { mk.right.equalTo(bubbleView.snp.left).inset(7) }
            mk.bottom.equalTo(bubbleView).inset(7)
        }
        
        if message.noReadUser.count > 0 { stackView.addArrangedSubview(readLabel) }
        if isLast { stackView.addArrangedSubview(timeLabel) }
        
        if incomming && isFirst{
            profile.snp.makeConstraints { (mk) in
                mk.left.equalTo(self).offset(4)
                mk.width.height.equalTo(40)
                mk.top.equalTo(topView.snp.bottom)
            }
        }
        
        if incomming {
            messageLabel.snp.remakeConstraints { (mk) in
                mk.left.equalTo(self).offset(Style.leftMessageToCornerGap)
                if isFirst { mk.top.equalTo(nameLabel.snp.bottom).offset(Style.nameLabelBubbleGap + Style.messagePadding) }
                else { mk.top.equalTo(topView.snp.bottom).offset(Style.messagePadding) }
                mk.width.lessThanOrEqualTo(250)
            }
            
        }else{
            messageLabel.snp.remakeConstraints { (mk) in
                mk.right.equalTo(self).offset(Style.rightMessageToCornerGap)
                mk.top.equalTo(topView.snp.bottom).offset(Style.messagePadding)
                mk.width.lessThanOrEqualTo(250)
            }
        }
        if incomming && isFirst{
            nameLabel.snp.remakeConstraints { (mk) in
                mk.top.equalTo(profile.snp.top)
                mk.left.equalTo(bubbleView.snp.left)
            }
        }
        
        bubbleView.snp.remakeConstraints { (mk) in
            let padding = -CGFloat(Style.messagePadding)
            mk.edges.equalTo(messageLabel).inset(UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        }
        
        for element in self.subs{
            element.snp.makeConstraints { (mk) in
                mk.bottom.lessThanOrEqualTo(self)
            }
        }
    }
    func clear(){
        self.subviews.forEach { (sub) in
            sub.snp.removeConstraints()
            sub.removeFromSuperview()
        }
    }
}

