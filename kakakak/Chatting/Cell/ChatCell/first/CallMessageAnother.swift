
import Foundation
import UIKit
class CallMessageAnother: UserChattingBaseAnotherCell,ChattingCellProtocol{
    func configure(message: Message, bgType: BgType) {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.message = message
        
        
        if message.isLastMessage{
            timeReadLabel.setUp(message: message, timeColor: bgType.getNavUserCountColor())
            timeReadLabel.isHidden = false
        }else{
            timeReadLabel.isHidden = true
        }
        
        
        //        timeReadLabel.setUp(message: message)
        
        let callImageAndTitle: (title: String, image: UIImage) = message.getTitleAndCallImage()
        
        callImage.image = callImageAndTitle.image
        callLabel.text = callImageAndTitle.title
    }
    
    
    
    @IBOutlet var bubble: UIView!
    
    
    @IBOutlet var callLabel: UILabel!
    @IBOutlet var callImage: UIImageView!
    static var reuseId: String{
        return "callMessageAnother"
    }
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
