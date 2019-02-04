import UIKit
class DeleteMessageAnother: BaseChat, ChattingCellProtocol{
    
    static var reuseId: String{
        return "deleteMessageAnother"
    }
    
    @IBOutlet var topLayout: NSLayoutConstraint!
    @IBOutlet var timeReadLabel: TimeAndReadLabel!
    @IBOutlet var warningVIew: UIImageView!
    func configure(message: Message) {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        timeReadLabel.setUp(message: message)
        topLayout.constant = message.isFirstMessage ? Style.firstMessageGap : Style.moreThanFirstMessageGap
        updateConstraintsIfNeeded()
        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
