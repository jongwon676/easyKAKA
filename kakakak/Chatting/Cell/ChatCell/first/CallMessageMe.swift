import UIKit
class CallMessageMe: UserChattingBaseMeCell, ChattingCellProtocol{
    
    static var reuseId: String{ return "callMessageMe" }
    
    
    
    @IBOutlet var callImage: UIImageView!
    @IBOutlet var callLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    
    func configure(message: Message) {
        
        
        
        self.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        guard let owner = message.owner else { return  }
        profile.isHidden = !message.isFirstMessage
        nameLabel.isHidden = !message.isFirstMessage
        
        nameLabel.text = owner.name
        //기본이미지가 셋팅 안된경우. 잘 처리하기
        profile.image = UIImage.loadImageFromName(owner.profileImageUrl ?? "")
        
        
        let callImageAndTitle: (title: String, image: UIImage) = message.getTitleAndCallImage()
        timeReadLabel.setUp(message: message)
        callImage.image = callImageAndTitle.image
        callLabel.text = callImageAndTitle.title
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

