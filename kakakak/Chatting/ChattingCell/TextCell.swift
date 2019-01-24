import UIKit
import SnapKit
import RealmSwift

class TextCell: UserChattingBaseCell{

    static var reuseId: String = "TextCell"
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = Style.messageLabelFont
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
    func configure(message: Message){
        guard let owner = message.owner else { return }
        
        containerView.addSubview(bubbleView)
        containerView.addSubview(messageLabel)
        
        
        self.message = message
        let screenWidth = UIScreen.main.bounds.width
        containerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 200)
        
        let profileX: CGFloat = Style.profileToCornerGap
        let profileY: CGFloat = 0
        let profileWidth = Style.profileImageSize
        let profileHeight = Style.profileImageSize
        profile.frame = CGRect(x: profileX, y: profileY, width: profileWidth, height: profileHeight)
        
        let nameLabelX = profile.frame.maxX + Style.nameLabelProfileGap
        let nameLabelY = profile.frame.origin.y
        nameLabel.frame.origin = CGPoint(x: nameLabelX, y: nameLabelY)
        nameLabel.sizeToFit()
        
        
        // messageLabel origin setting need
        messageLabel.text = message.messageText
        messageLabel.frame.size = messageLabel.sizeThatFits(CGSize(width: Style.limitMessageWidth, height: .infinity))


        //bubbleview origin setting need
        bubbleView.backgroundColor = incomming ? #colorLiteral(red: 0.9996673465, green: 0.8927946687, blue: 0.005554047879, alpha: 1) : #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1)
        bubbleView.frame.size = messageLabel.frame.size
        bubbleView.frame.size.width += 2 * Style.messagePadding
        bubbleView.frame.size.height += 2 * Style.messagePadding
        
        
        // bubbleview 의 origin을 셋팅하고 messageLabel의 센터를 버블뷰의 센터에 고정 시키자.
        
        if owner.isMe{
            bubbleView.frame.origin.x = nameLabelX
            let bubbleViewY = message.isFirstMessage ? nameLabel.frame.maxY + Style.nameLabelBubbleGap : 0
            bubbleView.frame.origin.y = bubbleViewY
            stackView.frame.origin.y = bubbleView.frame.maxY - stackView.frame.height
            stackView.frame.origin.x = bubbleView.frame.maxX + Style.timeLabelToMessageGap
            
        }else{
            bubbleView.frame.origin.x = UIScreen.main.bounds.width - bubbleView.frame.width - Style.profileToCornerGap
            bubbleView.frame.origin.y = 0
            stackView.frame.origin.y = bubbleView.frame.maxY - stackView.frame.height
            stackView.frame.origin.x = bubbleView.frame.minX - stackView.frame.width - Style.timeLabelToMessageGap
        }
        
        containerView.frame.size.height = bubbleView.frame.maxY
        messageLabel.center = bubbleView.center
        
        containerView.snp.remakeConstraints { (mk) in
            mk.left.right.top.bottom.equalTo(self)
            mk.height.equalTo(bubbleView.frame.maxY)
        }
        
        
        
    }

        
        
}


extension TextCell{
    static func calcHeight(message: Message) -> CGFloat{
        guard let owner = message.owner else { return 10 }
        
//        return 60
        let messageSize = SizeCalculator.calcLabelSize(string: message.messageText, font: Style.messageLabelFont, limitWidth: Style.limitMessageWidth, limitHeight: .infinity, numberOfLines: 0)
        
        var height = Style.basicTopGap + messageSize.height + 2 * Style.messagePadding
        
        
        if message.isFirstMessage{
            height += Style.firstMessageGap
            
            if !owner.isMe {
                let usernameSize = SizeCalculator.calcLabelSize(string: owner.name, font: Style.nameLabelFont, limitWidth: Style.limitUsernameWidth, limitHeight: .infinity,numberOfLines: 1)
                height += usernameSize.height + Style.nameLabelBubbleGap
            }
        }
        
        
        return height
        
    }
}
