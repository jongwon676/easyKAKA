
import Foundation
import UIKit
class CallMessageAnother: BaseChat,ChattingCellProtocol{
    @IBOutlet var bubble: UIView!
    
    @IBOutlet var timeReadLabel: TimeAndReadLabel!
    @IBOutlet var callLabel: UILabel!
    @IBOutlet var callImage: UIImageView!
    static var reuseId: String{
        return "callMessageAnother"
    }
    
    
    @IBOutlet var bubbleTop: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(message: Message) {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        bubbleTop.constant = message.isFirstMessage ? Style.firstMessageGap : Style.moreThanFirstMessageGap
        updateConstraintsIfNeeded()
        
        
            timeReadLabel.setUp(message: message)
        
//        timeReadLabel.setUp(message: message)
        
        let callImageAndTitle: (title: String, image: UIImage) = message.getTitleAndCallImage()
        
        callImage.image = callImageAndTitle.image
        callLabel.text = callImageAndTitle.title
    }
}
