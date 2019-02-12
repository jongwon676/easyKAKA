import UIKit
import SnapKit
class TextMe: UserChattingBaseMeCell,ChattingCellProtocol{
    func configure(message: Message, bgType: BgType) {
        self.message = message
        self.backgroundColor = UIColor.clear
        self.containerView.backgroundColor = UIColor.clear
        
        self.bubble.backgroundColor = Style.leftBubbleColor
        messageLabel.text = message.messageText
        moveConstraint()
        
        
        bubble.layer.cornerRadius = 2
        
        updateConstraintsIfNeeded()
    }
    
    
    
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
    
    override func draw(_ rect: CGRect) {
        

        if self.message.isFirstMessage{
            let path = UIBezierPath()
            let points = DrawHelper.drawTail(dir: .left, cornerPoint: bubble.frame.origin)
                path.move(to: points[0])
                path.addLine(to: points[1])
                path.addLine(to: points[2])
                path.addLine(to: points[3])
                path.close()
                bubble.backgroundColor?.setFill()
                path.fill()
        }
        
    }
    
    
    
}

extension Int{
    func div3() -> CGFloat{
        return CGFloat(self) / CGFloat(3)
    }
}
