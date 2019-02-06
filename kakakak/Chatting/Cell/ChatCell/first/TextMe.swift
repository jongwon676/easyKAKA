import UIKit
import SnapKit
class TextMe: UserChattingBaseMeCell,ChattingCellProtocol{
    static var reuseId = "textMe"
    
    
    //
    
    @IBOutlet var bubble: UIView!
    @IBOutlet var messageLabel: UILabel!
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configure(message: Message){
        self.message = message
        self.backgroundColor = UIColor.clear
        self.containerView.backgroundColor = UIColor.clear
        
        self.bubble.backgroundColor = Style.leftBubbleColor
        messageLabel.text = message.messageText


        moveConstraint()

        
        
        updateConstraintsIfNeeded()
        
    }
    
}
