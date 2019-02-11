import UIKit
class CallMessageMe: UserChattingBaseMeCell, ChattingCellProtocol{
    func configure(message: Message, bgType: BgType) {
        self.message = message
        
        self.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        //기본이미지가 셋팅 안된경우. 잘 처리하기
        let callImageAndTitle: (title: String, image: UIImage) = message.getTitleAndCallImage()
        callImage.image = callImageAndTitle.image
        callLabel.text = callImageAndTitle.title
        moveConstraint()
    }
    
    
    
    
    static var reuseId: String{ return "callMessageMe" }
    
    
    
    @IBOutlet var callImage: UIImageView!
    @IBOutlet var callLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

