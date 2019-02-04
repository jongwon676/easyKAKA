import UIKit
class RecordMessageAnother: BaseChat,ChattingCellProtocol{
    @IBOutlet var timeReadLabel: TimeAndReadLabel!
    @IBOutlet var playRecordLabel: UILabel!
    static var reuseId: String{
        return "recordMessageAnother"
    }
    
    @IBOutlet var topLayout: NSLayoutConstraint!
    func configure(message: Message) {
        self.contentView.backgroundColor = UIColor.clear
        
        self.backgroundColor = UIColor.clear
        if message.isFirstMessage{
            topLayout.constant = Style.firstMessageGap
        }else{
            topLayout.constant = Style.moreThanFirstMessageGap
        }
        timeReadLabel.setUp(message: message)
        updateConstraintsIfNeeded()
        playRecordLabel.text = ""
        playRecordLabel.text! += String(message.duration / 60)
        let secondString = String(message.duration % 60)
        playRecordLabel.text! += secondString.count < 2 ? ":0" + secondString : ":" + secondString
    }
    
    
}
