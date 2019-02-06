import UIKit
class CallMessageMe: BaseChat, ChattingCellProtocol{
    
    static var reuseId: String{ return "callMessageMe" }
    
    @IBOutlet var profile: ChatRadiusProfileView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var callImage: UIImageView!
    @IBOutlet var callLabel: UILabel!
    @IBOutlet var timeReadLabel: TimeAndReadLabel!
    
    @IBOutlet var leading: NSLayoutConstraint!
    
    @IBOutlet var first: NSLayoutConstraint!
    
    @IBOutlet var second: NSLayoutConstraint!
    
    @IBOutlet var containerView: UIView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    
    func configure(message: Message) {
        if message.isFirstMessage{
            NSLayoutConstraint.activate([first])
            NSLayoutConstraint.deactivate([second])
        }else{
            NSLayoutConstraint.activate([second])
            NSLayoutConstraint.deactivate([first])
        }
        
        
        self.backgroundColor = UIColor.clear
        self.containerView.backgroundColor = UIColor.clear
        guard let owner = message.owner else { return  }
        profile.isHidden = !message.isFirstMessage
        nameLabel.isHidden = !message.isFirstMessage
        
        nameLabel.text = owner.name
        //기본이미지가 셋팅 안된경우. 잘 처리하기
        profile.image = UIImage.loadImageFromName(owner.profileImageUrl ?? "")
        leading.constant = editMode ? 30 : 0
        
        let callImageAndTitle: (title: String, image: UIImage) = message.getTitleAndCallImage()
        timeReadLabel.setUp(message: message)
        callImage.image = callImageAndTitle.image
        callLabel.text = callImageAndTitle.title
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        NSLayoutConstraint.deactivate([first,second])
    }
}

