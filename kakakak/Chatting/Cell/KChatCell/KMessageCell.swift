import UIKit
import SnapKit

class KMessageCell: KBaseCell,ChattingCellProtocol{
    
    static var reuseId: String {
        return "KMessageCell"
    }
    lazy var profile: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var nameLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    let bubbleTExt: UILabel = {
        let label = UILabel()
        return label
    }()

    func configure(message: Message, bgType: BgType) {
        
    }
    
    override func layoutSubviews() {
        
    }
}
