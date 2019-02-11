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
        
//        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 150, right: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        registerCells()
        self.keyboardDismissMode = .interactive
        self.allowsSelection = false
        self.tableFooterView = UIView()
        self.separatorStyle = .none
        self.isUserInteractionEnabled = true
    }
    
    

    private func registerCells(){
        
    }
}
