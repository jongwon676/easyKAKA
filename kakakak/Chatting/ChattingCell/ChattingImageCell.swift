import UIKit
import SnapKit
import RealmSwift

class ChattingImageCell: UserChattingBaseCell,ChattingCellProtocol{
    static var reuseId: String = Message.MessageType.image.rawValue
    lazy var messageImage: UIImageView = {
        let image = UIImageView()
        
        return image
    }()
    
    
    func imgViewSize() -> CGSize{
        return CGSize(width: 100, height: 100)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
    }
    
    func configure(message: Message){
        messageImage.image = UIImage.loadImageFromName(message.messageImageUrl)
        self.addSubview(messageImage)
        
        
//        topView.snp.remakeConstraints { (mk) in
//            mk.left.right.top.equalTo(self)
//            mk.height.equalTo( ( message.isFirstMessage ? Style.firstMessageGap + 4 : 4 ) )
//        }
        
        messageImage.snp.remakeConstraints { (mk) in
//            if incomming { mk.left.equalTo(self).offset(Style.leftMessageToCornerGap)}
//            else {mk.right.equalTo(self).inset(Style.rightMessageToCornerGap)}
            mk.size.equalTo(imgViewSize())
            mk.top.equalTo(self).offset(message.isFirstMessage ? Style.firstMessageGap + 4 : 4)
//            mk.top.equalTo(topView.snp.bottom)
            mk.bottom.equalTo(self)
        }
        
        stackView.snp.remakeConstraints { (mk) in
//            if incomming { mk.left.equalTo(messageImage.snp.right).offset(7) }
//            else { mk.right.equalTo(messageImage.snp.left).offset(-7) }
            mk.bottom.equalTo(messageImage).inset(7)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
