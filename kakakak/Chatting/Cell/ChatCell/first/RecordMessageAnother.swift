import UIKit
class RecordMessageAnother: UserChattingBaseAnotherCell,ChattingCellProtocol{
    
    @IBOutlet var playRecordLabel: UILabel!
    static var reuseId: String{
        return "recordMessageAnother"
    }
    

    func configure(message: Message) {
        self.contentView.backgroundColor = UIColor.clear
        self.message = message
        self.backgroundColor = UIColor.clear
        
        if message.isLastMessage{
            timeReadLabel.setUp(message: message)
            timeReadLabel.isHidden = false
        }else{
            timeReadLabel.isHidden = true
        }
        
        updateConstraintsIfNeeded()
        playRecordLabel.text = ""
        playRecordLabel.text! += String(message.duration / 60)
        let secondString = String(message.duration % 60)
        playRecordLabel.text! += secondString.count < 2 ? ":0" + secondString : ":" + secondString
    }
    
    
}
