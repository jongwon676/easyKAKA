import UIKit
class ImageMe: BaseChat,ChattingCellProtocol{
    static var reuseId = "imageMe"
    
    @IBOutlet var profile: ChatRadiusProfileView!
    @IBOutlet var messageImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var failView: UIImageView!
    @IBOutlet var timeReadLabel: UILabel!
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var bubble: CornerRadiusView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(message: Message) {
        self.backgroundColor = UIColor.clear
        self.containerView.backgroundColor = UIColor.clear
        
        profile.isHidden = !message.isFirstMessage
        nameLabel.isHidden = profile.isHidden
        failView.isHidden = !message.isFail
        timeReadLabel.isHidden = message.isFail
        
        
        
        bubble.snp.updateConstraints { (mk) in
            if message.isFirstMessage{
                mk.top.greaterThanOrEqualTo(nameLabel.snp.bottom).offset(Style.nameLabelBubbleGap)
            }else{
                mk.top.equalTo(containerView.snp.top).offset(Style.moreThanFirstMessageGap)
            }
        }
    }
}
