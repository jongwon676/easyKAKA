import UIKit
import Foundation
class KRecordCell: KMessageCell,ChattingCellProtocol{
    
    static var reuseId = "KRecordCell"

    let playImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "play")
        return imageView
    }()
    
    let waveImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "wave")
        return imageView
    }()
    
    let recordTimeLabel: UILabel = {
        let label = UILabel()
        label.font = Style.recordTimeLabelFont
        return label
    }()
    
    
    override func configure(message: Message, bgType: BgType) {
        
        self.message = message
        recordTimeLabel.text = KRecordCell.getDurationText(message: message)
        recordTimeLabel.sizeToFit()
        bubble.cornerRadius = 2
        super.configure(message: message, bgType: bgType)
        [playImageView,waveImageView,recordTimeLabel].forEach { (view) in
            bubble.addSubview(view)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews(size: KRecordCell.bubbleSize(message))
        playImageView.frame.size = Style.recordPlayImageSize
        waveImageView.frame.size = Style.recordWaveImageSize
        [playImageView,waveImageView,recordTimeLabel].forEach { (view) in
            view.center = bubble.center
            view.center.y -= bubble.frame.origin.y
        }
        
        
        
        playImageView.frame.origin.x = Style.recordPlayImageLeftGap
        waveImageView.frame.origin.x = playImageView.frame.maxX + Style.recordPlayImageToWaveImageGap
        recordTimeLabel.frame.origin.x = waveImageView.frame.maxX + Style.recrodWaveImageToTimeLabelGap
        
    }
    
    class func getDurationText(message: Message) -> String{
        var string = ""
         string += String(message.duration / 60)
        let secondString = String(message.duration % 60)
        string += secondString.count < 2 ? ":0" + secondString : ":" + secondString
        return string
    }
    
    
    class func bubbleSize(_ message: Message) -> CGSize{
        let text = getDurationText(message: message)
        let maxWidth = UIScreen.main.bounds.width * 1.0
        let rect = text.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: Style.recordTimeLabelFont], context: nil)
        let height = Style.recordBubbleCellHeight
        let width = Style.recordPlayImageLeftGap + Style.recordPlayImageSize.width + Style.recordPlayImageToWaveImageGap + Style.recordWaveImageSize.width + Style.recrodWaveImageToTimeLabelGap + Style.recordTimeLabelToRightGap + rect.width
        
        return CGSize(width: width, height: height)
    }
    
   
    
    
    
    class func height(message: Message) -> CGFloat{
        let bubbleSize = self.bubbleSize(message)
        guard let owner = message.owner else { return 0 }
        let nameHeight = super.nameLabelHeight(message)
        if message.isFirstMessage{
            if owner.isMe {
                return bubbleSize.height + Style.firstMessageGap
            }else{
                return bubbleSize.height + nameHeight + Style.nameLabelBubbleGap + Style.firstMessageGap
            }
        }else{
            return bubbleSize.height  + Style.moreThanFirstMessageGap
        }
    }
    
}
