import Foundation
import UIKit
import SnapKit

class EditView: UIView{
    
    var selectedChattingCount: Int = 0{
        didSet{
            editButton.isEnabled = (selectedChattingCount == 1)
            cancelButton.isEnabled = (selectedChattingCount >= 1)
            deleteButton.isEnabled = (selectedChattingCount >= 1)
            escButton.isEnabled = true
        }
    }
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택취소", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    lazy var escButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정모드 종료", for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.addArrangedSubview(editButton)
        view.addArrangedSubview(deleteButton)
        view.addArrangedSubview(cancelButton)
        view.addArrangedSubview(escButton)
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

protocol EditChatting{
    func excuteDelete()
    func excuteCancel()
    func excuetEdit()
    func excuteEsc()
}
