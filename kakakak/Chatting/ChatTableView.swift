import UIKit

class ChatTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        registerCells()
        self.keyboardDismissMode = .interactive
        self.allowsSelection = false
        self.tableFooterView = UIView()
        self.separatorStyle = .none
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func registerCells(){
        self.register(TextCell.self, forCellReuseIdentifier: TextCell.reuseId)
        self.register(GuideLineCell.self, forCellReuseIdentifier: GuideLineCell.reuseId)
        self.register(ChattingImageCell.self, forCellReuseIdentifier: ChattingImageCell.reuseId)
        self.register(DateCell.self, forCellReuseIdentifier: DateCell.reuseId)
        self.register(UserEnterCell.self, forCellReuseIdentifier: UserEnterCell.reuseId)
        self.register(UserExitCell.self, forCellReuseIdentifier: UserExitCell.reuseId)
        self.register(VoiceCell.self, forCellReuseIdentifier: VoiceCell.reuseId)
    }
}
