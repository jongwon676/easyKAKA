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
        button.setTitle("수정", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return button
    }()
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택취소", for: .normal)
        button.tag = 1
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return button
    }()
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택취소", for: .normal)
        button.tag = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return button
    }()
//    lazy var escButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("수정모드 종료", for: .normal)
//        button.tag = 3
//        button.titleLabel?.textAlignment = .center
//        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
//        return button
//    }()
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.addArrangedSubview(editButton)
        view.addArrangedSubview(deleteButton)
//        view.addArrangedSubview(cancelButton)
//        view.addArrangedSubview(escButton)
        return view
    }()
       
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (mk) in
            mk.left.right.bottom.top.equalTo(self)
        }
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
