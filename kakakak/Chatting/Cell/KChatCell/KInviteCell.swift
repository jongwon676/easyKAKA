import UIKit
import SnapKit
class KInviteCell: KBaseCell,ChattingCellProtocol{
    static var reuseId: String = "KInviteCell"
    let bgView = UIView()
    let inviteLabel = UILabel()
    
    func setupLayout(){
        contentView.addSubview(bgView)
        contentView.addSubview(inviteLabel)
        bgView.snp.makeConstraints { (mk) in
            mk.top.equalTo(Style.firstMessageGap)
            mk.left.bottom.right.equalTo(contentView)
        }
        inviteLabel.snp.makeConstraints { (mk) in
            mk.width.lessThanOrEqualTo(Style.inviteLabelMaxWidth)
            mk.centerX.equalTo(bgView)
            mk.top.equalTo(bgView).offset(Style.inviteLabelTopInset)
            mk.bottom.equalTo(bgView).inset(Style.inviteLabelBottomInset)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(message: Message, bgType: BgType) {
        bgView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)
        
        inviteLabel.font = Style.inviteLabelFont
        inviteLabel.text = message.messageText
        inviteLabel.frame.size.width = Style.inviteLabelMaxWidth
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func height(message: Message) -> CGFloat{
        let maxWidth = Style.inviteLabelMaxWidth
        let inviteText = message.messageText
        
        let rect = inviteText.boundingRect(with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: Style.inviteLabelFont], context: nil)
        
        return rect.height + Style.firstMessageGap + Style.inviteLabelBottomInset + Style.inviteLabelTopInset
    }
}
