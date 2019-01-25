import UIKit
import SnapKit
class UserChattingBaseCell: BaseChatCell{
    var message: Message! {
        didSet{
            
            timeLabel.text = Date.timeToString(date: message.sendDate)
            timeLabel.isHidden = !message.isLastMessage
            readLabel.text = String(message.noReadUser.count)
            readLabel.isHidden = (message.noReadUser.count <= 0)
            nameLabel.text = message.owner?.name
            
            
            readLabel.sizeToFit()
            timeLabel.sizeToFit()
            
            if let owner = message.owner{
                nameLabel.isHidden = (owner.isMe || !message.isFirstMessage)
                profile.isHidden = nameLabel.isHidden
                if let profileImageUrl = owner.profileImageUrl{
                    profile.image = UIImage.loadImageFromName(profileImageUrl)
                }
            }
//            stackView.alignment = incomming ? .leading : .trailing
            stackView.subviews.forEach{ $0.removeFromSuperview() }
            if message.noReadUser.count > 0 { stackView.addArrangedSubview(readLabel) }
            if message.isLastMessage { stackView.addArrangedSubview(timeLabel) }
            
            
            
            
        }
    }
    lazy var nameLabel: UILabel = {
        var label = UILabel()
        label.font = Style.nameLabelFont
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
        label.font = Style.timeLabelFont
        return label
    }()
    
    lazy var readLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9955037236, green: 0.9007681012, blue: 0, alpha: 1)
        label.font = Style.readLabelFont
        return label
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
