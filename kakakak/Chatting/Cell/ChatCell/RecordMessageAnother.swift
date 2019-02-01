import UIKit
class RecordMessageAnother: BaseChat,ChattingCellProtocol{
    @IBOutlet var timeReadLabel: TimeAndReadLabel!
    @IBOutlet var playRecordLabel: UILabel!
    static var reuseId: String{
        return "recordMessageAnother"
    }
    
    @IBOutlet var topLayout: NSLayoutConstraint!
    func configure(message: Message) {
        self.backgroundColor = UIColor.clear
        if message.isFirstMessage{
            topLayout.constant = Style.firstMessageGap
        }else{
            topLayout.constant = Style.moreThanFirstMessageGap
        }
        updateConstraintsIfNeeded()
    }
    
    
}
