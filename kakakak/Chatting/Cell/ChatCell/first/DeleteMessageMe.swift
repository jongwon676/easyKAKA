
import UIKit
import SnapKit
class DeleteMessageMe: UserChattingBaseMeCell,ChattingCellProtocol {
    
    
    
    
    static var reuseId: String{
        return "deleteMessageMe"
    }

    @IBOutlet var deleteLabel: UILabel!
    
    
    
    @IBOutlet var warningView: UIImageView!
    @IBOutlet var bubble: UIView!
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func configure(message: Message, bgType: BgType) {
        self.message = message
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.clear
        moveConstraint()
        bubble.layer.cornerRadius = 2
        updateFocusIfNeeded()
        
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
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profile.image = nil
        nameLabel.text = ""
    }
}
