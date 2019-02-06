import Foundation
import UIKit
import SnapKit

class EditView: UIView{
    weak var delegate: EditChatting?
    
    var selectedMsgType: Message.MessageType = .text
    func canEdit(type: Message.MessageType) -> Bool{
        switch type {
            case .text: return true
            case .image: return true
            case .enter: return false
            case .exit: return false
            case .date: return true
            case .call: return false
            case .record: return true
            case .delete: return false
        }
    }
    var selectedChattingCount: Int = 0{
        didSet{
            editButton.isEnabled = (selectedChattingCount == 1) && canEdit(type: selectedMsgType)
            deleteButton.isEnabled = (selectedChattingCount >= 1)
            timeEditButton.isEnabled = (selectedChattingCount >= 1)
        }
    }
    
    @objc func buttonClicked(_ sender: UIButton){
        
        switch sender.tag {
        case 0: delegate?.excuetEdit()
        case 1: delegate?.excuteDelete()
        case 2: delegate?.excuteTimeEdit()
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
    
    lazy var timeEditButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(#imageLiteral(resourceName: "timeModify"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(editButton)
        self.addSubview(deleteButton)
        self.addSubview(timeEditButton)
        
    }
    override func layoutSubviews() {
        let firstArea = self.bounds.slice(num: 3, at: 0)
        let secondArea = self.bounds.slice(num: 3, at: 1)
        let thirdArea = self.bounds.slice(num: 3, at: 2)

        self.backgroundColor = UIColor.white
        editButton.frame.size = CGSize(width: 30, height: 38)
        deleteButton.frame.size = CGSize(width: 30, height: 38)
        timeEditButton.frame.size = CGSize(width: 30, height: 38)
        
        
        
        editButton.center = firstArea.center
        deleteButton.center = secondArea.center
        timeEditButton.center = thirdArea.center
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol EditChatting: class{
    func excuteDelete()
    func excuteTimeEdit()
    func excuetEdit()
    func excuteEsc()
}
