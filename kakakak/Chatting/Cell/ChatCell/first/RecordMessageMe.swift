
import UIKit
class RecordMessageMe: UserChattingBaseMeCell,ChattingCellProtocol{
    static var reuseId: String{
        return "recordMessageMe"
    }
    
    
    
    
    
    @IBOutlet var playTimeLabel: UILabel!

    
    func configure(message: Message) {
        self.message = message
        self.containerView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        playTimeLabel.text = ""
        playTimeLabel.text! += String(message.duration / 60)
        let secondString = String(message.duration % 60)
        playTimeLabel.text! += secondString.count < 2 ? ":0" + secondString : ":" + secondString
        
        moveConstraint()
    }
    
    
}
