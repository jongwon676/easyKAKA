import UIKit
class DeleteMessageAnother: UserChattingBaseAnotherCell, ChattingCellProtocol{
    
    static var reuseId: String{
        return "deleteMessageAnother"
    }
    
    
    
    @IBOutlet var warningVIew: UIImageView!
    func configure(message: Message) {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        timeReadLabel.setUp(message: message)
        
        
        updateConstraintsIfNeeded()
        
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
