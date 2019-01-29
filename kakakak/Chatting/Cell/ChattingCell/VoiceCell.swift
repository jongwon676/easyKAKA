import UIKit
class VoiceCell: UserChattingBaseCell,ChattingCellProtocol{
    static var reuseId: String = Message.MessageType.voice.rawValue
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    lazy var bubble: UIView = {
        let view = UIView()
        view.backgroundColor = Style.bubbleWhiteColor
        view.layer.cornerRadius = Style.bubbleCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    let voiceImage = UIImageView()
    let voiceLabel = UILabel()
    
    func voiceBubbleHeight() -> CGSize{
        let text = NSAttributedString(string: voiceLabel.text!, attributes: [NSAttributedString.Key.font: voiceLabel.font])
        let textSize = text.size()
        return CGSize(width: 3 * Style.voicePadding + Style.voiceImageSize + CGFloat(textSize.width)
            , height: 2 * Style.voicePadding + Style.voiceImageSize)
    }
    
    
    func configure(message message: Message){
        self.message = message
        
        voiceLabel.text = "보이스 해요"
        voiceImage.image = UIImage(named: "enter")
        self.addSubview(bubble)
        bubble.addSubview(voiceImage)
        bubble.addSubview(voiceLabel)
        
        bubble.snp.remakeConstraints { (mk) in
            mk.left.equalTo(profile).offset(Style.leftMessageToCornerGap)
            mk.top.equalTo(nameLabel).offset(Style.nameLabelBubbleGap)
            mk.size.equalTo(voiceBubbleHeight())
            mk.bottom.equalTo(self)
        }
        voiceImage.snp.remakeConstraints { (mk) in
            mk.centerY.equalTo(bubble)
            mk.left.equalTo(bubble).offset(Style.voicePadding)
            mk.width.height.equalTo(Style.voiceImageSize)
        }
        voiceLabel.snp.remakeConstraints { (mk) in
            mk.left.equalTo(voiceImage.snp.right).offset(Style.voicePadding)
            mk.centerY.equalTo(bubble)
        }
        profile.snp.remakeConstraints { (mk) in
            mk.left.equalTo(Style.profileToCornerGap)
            mk.top.equalTo(self).offset(0)
            mk.width.height.equalTo(Style.profileImageSize)
        }
    }
}
