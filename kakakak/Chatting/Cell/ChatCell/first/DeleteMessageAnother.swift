import UIKit
class DeleteMessageAnother: UserChattingBaseAnotherCell, ChattingCellProtocol{
    
    
    
    
    static var reuseId: String{
        return "deleteMessageAnother"
    }
    
    
    @IBOutlet var bubble: CornerRadiusView!{
        didSet{
            bubble.backgroundColor = Style.rightBubbleColor
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        
        if self.message.isFirstMessage{
            let path = UIBezierPath()
            let points = DrawHelper.drawTail(dir: .right, cornerPoint: bubble.frame.rightTopCorner)
            path.move(to: points[0])
            path.addLine(to: points[1])
            path.addLine(to: points[2])
            path.addLine(to: points[3])
            path.close()
            
            bubble.backgroundColor?.setFill()
            path.fill()
        }
    }
    
    @IBOutlet var warningVIew: UIImageView!
  
    func configure(message: Message, bgType: BgType) {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.message = message
        if message.isLastMessage{
            timeReadLabel.setUp(message: message, timeColor: bgType.getNavUserCountColor())
            timeReadLabel.isHidden = false
        }else{
            timeReadLabel.isHidden = true
        }
        
        bubble.layer.cornerRadius = 2
        
        updateConstraintsIfNeeded()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
