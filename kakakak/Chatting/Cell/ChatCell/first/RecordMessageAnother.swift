import UIKit
class RecordMessageAnother: UserChattingBaseAnotherCell,ChattingCellProtocol{
    func configure(message: Message, bgType: BgType) {
        self.contentView.backgroundColor = UIColor.clear
        self.message = message
        self.backgroundColor = UIColor.clear
        
        timeReadLabel.setUp(message: message, timeColor: bgType.getNavUserCountColor())
        
        updateConstraintsIfNeeded()
        playRecordLabel.text = ""
        playRecordLabel.text! += String(message.duration / 60)
        let secondString = String(message.duration % 60)
        playRecordLabel.text! += secondString.count < 2 ? ":0" + secondString : ":" + secondString
        bubble.cornerRadius = 2
    }
    
    
    
    @IBOutlet var bubble: CornerRadiusView!
    
    @IBOutlet var playRecordLabel: UILabel!
    static var reuseId: String{
        return "recordMessageAnother"
    }
    

    
    
    
}
