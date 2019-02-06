import UIKit
class RecordMessageAnother: UserChattingBaseAnotherCell,ChattingCellProtocol{
    
    @IBOutlet var playRecordLabel: UILabel!
    static var reuseId: String{
        return "recordMessageAnother"
    }
    

    func configure(message: Message) {
        self.contentView.backgroundColor = UIColor.clear
        
        self.backgroundColor = UIColor.clear
        timeReadLabel.setUp(message: message)
        updateConstraintsIfNeeded()
        playRecordLabel.text = ""
        playRecordLabel.text! += String(message.duration / 60)
        let secondString = String(message.duration % 60)
        playRecordLabel.text! += secondString.count < 2 ? ":0" + secondString : ":" + secondString
    }
    
    
}
