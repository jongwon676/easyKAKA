import Foundation
import UIKit
import SnapKit

class EditView: UIView{
    weak var delegate: EditChatting?
    var selectedChattingCount: Int = 0{
        didSet{
            editButton.isEnabled = (selectedChattingCount == 1)
            deleteButton.isEnabled = (selectedChattingCount >= 1)
            
        }
    }
    @objc func buttonClicked(_ sender: UIButton){
        
        switch sender.tag {
        case 0: delegate?.excuetEdit()
        case 1: delegate?.excuteDelete()
        case 2: delegate?.excuteCancel()
        case 3: delegate?.excuteEsc()
        default: break
        }
    }
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.tag = 0
        
        button.setImage(UIImage(named: "modify_disabled"), for: .disabled)
        button.setImage(UIImage(named: "modify"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return button
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "delete_disabled"), for: .disabled)
        button.setImage(UIImage(named: "delete"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 1
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return button
    }()

    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(editButton)
        self.addSubview(deleteButton)
    }
    override func layoutSubviews() {
        let leftArea = self.bounds.leftHalf
        let rightArea = self.bounds.rightHalf
        editButton.frame.size = CGSize(width: 30, height: 38)
        deleteButton.frame.size = CGSize(width: 30, height: 38)
        editButton.center = leftArea.center
        deleteButton.center = rightArea.center
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol EditChatting: class{
    func excuteDelete()
    func excuteCancel()
    func excuetEdit()
    func excuteEsc()
}
