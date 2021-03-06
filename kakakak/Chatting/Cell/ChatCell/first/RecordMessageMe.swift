
import UIKit
class RecordMessageMe: UserChattingBaseMeCell,ChattingCellProtocol{
    @IBOutlet var bubble: CornerRadiusView!
    func configure(message: Message, bgType: BgType) {
        self.message = message
        self.containerView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        playTimeLabel.text = ""
        playTimeLabel.text! += String(message.duration / 60)
        let secondString = String(message.duration % 60)
        playTimeLabel.text! += secondString.count < 2 ? ":0" + secondString : ":" + secondString
        
        moveConstraint()
        bubble.cornerRadius = 2
    }
    
    
    
    static var reuseId: String{
        return "recordMessageMe"
    }
    
    
    
    
    
    @IBOutlet var playTimeLabel: UILabel!

    
    
    
    
}
