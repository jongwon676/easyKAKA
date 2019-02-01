import UIKit
class DeleteMessageAnother: BaseChat, ChattingCellProtocol{
    
    static var reuseId: String{
        return "deleteMessageAnother"
    }
    
    @IBOutlet var topLayout: NSLayoutConstraint!
    @IBOutlet var timeReadLabel: UILabel!
    @IBOutlet var warningVIew: UIImageView!
    func configure(message: Message) {
        self.backgroundColor = UIColor.clear
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
