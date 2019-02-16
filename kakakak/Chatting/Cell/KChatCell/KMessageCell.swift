import UIKit
import SnapKit

class KMessageCell: KBaseCell{
    
    
    lazy var bubble: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var profile: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var nameLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    lazy var timeReadLabel: TimeAndReadLabel = {
        let label = TimeAndReadLabel()
        return label
    }()
    
    
    lazy var subViews: [UIView] = [ bubble,profile,nameLabel,timeReadLabel ]
    
    func addSubViews(_ isLeft: Bool){
        if isLeft {
            subViews.forEach{ (subView) in
                containerView.addSubview(subView)
            }
        }else{
            subViews.forEach{ (subView) in
                self.addSubview(subView)
            }
        }
    }
    
    func configure(message: Message, bgType: BgType) {
        
        
        
        timeReadLabel.setUp(message: message, timeColor: bgType.chattingTimeColor)
        nameLabel.font = Style.nameLabelFont
        nameLabel.textColor = bgType.userNameColor
        
        guard let owner = message.owner else { return }
        profile.image = UIImage.loadImageFromName(owner.profileImageUrl ?? "")
        nameLabel.text = owner.name
        addSubViews(!owner.isMe)
        
        bubble.backgroundColor = UIColor.white
        
        if !owner.isMe  && message.isFirstMessage{
            profile.isHidden = false
            nameLabel.isHidden = false
        }else{
            profile.isHidden = true
            nameLabel.isHidden = true
        }
    }
    
    func setupLayoutLeftSide(bubbleSize: CGSize){
    
        profile.frame = CGRect(x: Style.profileToLeftCornerGap, y: Style.firstMessageGap, width: Style.profileSize, height: Style.profileSize)
        nameLabel.frame.origin = CGPoint(x: profile.frame.maxX + Style.bubbleProfileGap, y: profile.frame.minY)
        
        
        
        nameLabel.sizeToFit()
        
        if message.isFirstMessage{
            bubble.frame = CGRect(origin: CGPoint(x: nameLabel.frame.minX, y: nameLabel.frame.maxY + Style.nameLabelBubbleGap), size: bubbleSize)
        }else{
            bubble.frame = CGRect(origin: CGPoint(x: nameLabel.frame.minX, y: Style.moreThanFirstMessageGap), size: bubbleSize)
        }
        let timeHeight = timeReadLabel.frame.height
        timeReadLabel.frame.origin = CGPoint(
            x: bubble.frame.maxX + Style.bubbleToTimeSideGap,
            y: bubble.frame.maxY - Style.bubbleToTimeBottomGap - timeHeight)
    }
    
    func setupLayoutRightSide(bubbleSize: CGSize){
        
        let bubbleYGap = message.isFirstMessage ? Style.firstMessageGap : Style.moreThanFirstMessageGap
        bubble.frame.origin = CGPoint(x: bubble.superview!.frame.width - bubbleSize.width - Style.bubbleToRightCornerGap, y: bubbleYGap)
        bubble.frame.size = bubbleSize
        
        let timeHeight = timeReadLabel.frame.height
        let timeWidth = timeReadLabel.frame.width
        timeReadLabel.frame.origin = CGPoint(
            x: bubble.frame.minX - timeWidth - Style.bubbleToTimeSideGap,
            y: bubble.frame.maxY - Style.bubbleToTimeBottomGap - timeHeight)
    }
    
    
    func layoutSubviews(size: CGSize){ // 멀 넘겨주냐면, 버블의 크기를 넘겨줌.
        super.layoutSubviews()
        
        guard let owner = message.owner else { return }
        if owner.isMe{
            setupLayoutRightSide(bubbleSize: size)
        }else{
            setupLayoutLeftSide(bubbleSize: size)
        }
    }
    class func nameLabelHeight(_ message: Message) -> CGFloat{
        let maxWidth = UIScreen.main.bounds.width * 1.0
        let rect = message.messageText.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: Style.nameLabelFont], context: nil)
        return rect.height
    }
    
}
