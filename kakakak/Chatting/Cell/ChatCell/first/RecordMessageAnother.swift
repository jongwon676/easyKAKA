import UIKit
class RecordMessageAnother: UserChattingBaseAnotherCell,ChattingCellProtocol{
    func configure(message: Message, bgType: BgType) {
        self.contentView.backgroundColor = UIColor.clear
        self.message = message
        self.backgroundColor = UIColor.clear
        
        if message.isLastMessage{
            timeReadLabel.setUp(message: message, timeColor: bgType.getNavUserCountColor())
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
    
    
    
    
    @IBOutlet var playRecordLabel: UILabel!
    static var reuseId: String{
        return "recordMessageAnother"
    }
    

    
    
    
}
