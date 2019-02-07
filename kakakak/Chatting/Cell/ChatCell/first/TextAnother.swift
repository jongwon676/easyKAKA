import UIKit
class TextAnother: UserChattingBaseAnotherCell,ChattingCellProtocol{
    static var reuseId = "textAnother"
  
    @IBOutlet var messageLabel: UILabel!
    
    
    @IBOutlet var failView: UIImageView!
    
    
    @IBOutlet var bubble: CornerRadiusView!
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(message: Message){
        self.message = message
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.bubble.backgroundColor = Style.rightBubbleColor
        messageLabel.text = message.messageText
        failView.isHidden = !message.isFail
        if message.isLastMessage{

            timeReadLabel.setUp(message: message)
            timeReadLabel.isHidden = false
            timeReadLabel.isHidden = !failView.isHidden
        }else{
            timeReadLabel.isHidden = true
        }
    }
}
