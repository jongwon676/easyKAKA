import UIKit
import SnapKit
import RealmSwift

class ChattingImageCell: UserChattingBaseCell{
    static var reuseId = "ChattingImageCell"
    lazy var messageImage: UIImageView = {
        let image = UIImageView()
        self.addSubview(image)
        return image
    }()
    
    lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        return stackView
    }()
    
    func imgViewSize() -> CGSize{
        return CGSize(width: 100, height: 100)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.addSubview(topView)
    }
    
    func configure(_ message: Message){
        messageImage.image = UIImage.loadImageFromName(message.messageImageUrl)
        timeLabel.text = Date.timeToString(date: message.sendDate)
        readLabel.text = String(message.noReadUser.count)
        
        
        topView.snp.remakeConstraints { (mk) in
            mk.left.right.top.equalTo(self)
            mk.height.equalTo( ( message.isFirstMessage ? Style.firstMessageGap + 4 : 4 ) )
        }
        
        messageImage.snp.remakeConstraints { (mk) in
            if incomming { mk.left.equalTo(self).offset(Style.leftMessageToCornerGap)}
            else {mk.right.equalTo(self).inset(Style.rightMessageToCornerGap)}
            mk.size.equalTo(imgViewSize())
            mk.top.equalTo(topView.snp.bottom)
            mk.bottom.equalTo(self)
        }
        stackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        stackView.alignment = incomming ? .leading : .trailing
        stackView.snp.remakeConstraints { (mk) in
            if incomming { mk.left.equalTo(messageImage.snp.right).offset(7) }
            else { mk.right.equalTo(messageImage.snp.left).offset(-7) }
            mk.bottom.equalTo(messageImage).inset(7)
        }
        
        if message.noReadUser.count > 0 { stackView.addArrangedSubview(readLabel) }
        if message.isLastMessage { stackView.addArrangedSubview(timeLabel) }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
