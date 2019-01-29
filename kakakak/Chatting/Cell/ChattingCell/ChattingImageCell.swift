import UIKit
import SnapKit
import RealmSwift

class ChattingImageCell: UserChattingBaseCell,ChattingCellProtocol{
    static var reuseId: String = Message.MessageType.image.rawValue
    lazy var messageImage: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    
    func imgViewSize() -> CGSize{
        return CGSize(width: 100, height: 100)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
    }
    
    func configure(message: Message){
        self.message = message
        messageImage.image = UIImage.loadImageFromName(message.messageImageUrl)
        
        guard let owner = message.owner else { return }
        containerView.addSubview(stackView)
        containerView.addSubview(nameLabel)
        
        containerView.addSubview(messageImage)
        containerView.addSubview(profile)
        let screenWidth = UIScreen.main.bounds.width
        let containerViewY = message.isFirstMessage ? Style.firstMessageGap  : Style.moreThanFirstMessageGap
        containerView.frame = CGRect(x: 0, y: containerViewY, width: screenWidth, height: 200)
        let profileX: CGFloat = Style.profileToCornerGap + (editMode ? Style.editModeOffset : 0)
        let profileY: CGFloat = 0
        let profileWidth = Style.profileImageSize
        let profileHeight = Style.profileImageSize
        profile.frame = CGRect(x: profileX, y: profileY, width: profileWidth, height: profileHeight)
        let nameLabelX = profile.frame.maxX + Style.nameLabelProfileGap
        let nameLabelY = profile.frame.origin.y
        nameLabel.frame.origin = CGPoint(x: nameLabelX, y: nameLabelY)
        nameLabel.sizeToFit()
        
        
        messageImage.frame.size = CGSize(width: 100, height: 100) // 수정 요망
        
        
        if !owner.isMe{
            messageImage.frame.origin.x = nameLabelX
            let bubbleViewY = message.isFirstMessage ? nameLabel.frame.maxY + Style.nameLabelBubbleGap : 0
            messageImage.frame.origin.y = bubbleViewY
            stackView.snp.remakeConstraints { (mk) in
                mk.left.equalTo(messageImage.snp.right).offset(Style.timeLabelToMessageGap)
                mk.bottom.equalTo(messageImage.snp.bottom)
            }
        }else{
            messageImage.frame.origin.x = UIScreen.main.bounds.width - messageImage.frame.width - Style.profileToCornerGap
            messageImage.frame.origin.y = 0
            stackView.snp.remakeConstraints { (mk) in
                mk.right.equalTo(messageImage.snp.left).offset(-Style.timeLabelToMessageGap)
                mk.bottom.equalTo(messageImage.snp.bottom)
            }
        }
        
        
        
        
        containerView.frame.size.height = messageImage.frame.maxY
//        messageLabel.center = bubbleView.center
        
        containerView.snp.remakeConstraints { (mk) in
            mk.left.right.bottom.equalTo(self)
            mk.top.equalTo(self).offset(containerViewY)
            mk.height.equalTo(messageImage.frame.maxY)
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
