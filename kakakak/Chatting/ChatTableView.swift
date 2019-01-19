import UIKit

class ChatTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        registerCells()
        self.keyboardDismissMode = .interactive
        self.allowsSelection = false
        self.tableFooterView = UIView()
        self.separatorStyle = .none
        self.backgroundColor = #colorLiteral(red: 0.7427546382, green: 0.8191892505, blue: 0.8610599637, alpha: 1)
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
    }
}
