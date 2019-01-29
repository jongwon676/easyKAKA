import UIKit
import SnapKit
import RealmSwift

class MessageEditController: UITableViewController {
    
    
    
    static var allIndenties = ["UserNameCell","TimeCell","TextCell","DateCell"]
    weak var chatVc: ChatVC!
    enum cellKind:String{
        case UserNameCell
        case TimeCell
        case TextCell
        case DateCell
    }
    
    var messages: [Message] = []
    var cellKinds = [""]
    
    func getIndsWithMessageType() -> [String]{
        var indenties = [String]()
        if messages.count > 1 {
            indenties = [cellKind.TimeCell.rawValue]
        }else{
            switch messages.first!.type {
            case .date: indenties = [cellKind.DateCell.rawValue]
            case .enter: indenties = [cellKind.TimeCell.rawValue]
            case .exit: indenties = [cellKind.TimeCell.rawValue]
            case .image: indenties = [cellKind.TimeCell.rawValue]
            case .text: indenties = [
                cellKind.UserNameCell.rawValue,
                cellKind.TextCell.rawValue,
                cellKind.TimeCell.rawValue
                ]
            case .voice: indenties = [cellKind.TimeCell.rawValue]}
        }
        return indenties
    }
    
    var allCells: [UITableViewCell] {
        var cells:[UITableViewCell] = []
        for idx in 0 ..< self.cellKinds.count{
            cells.append(tableView.cellForRow(at: IndexPath.row(row: idx))!)
        }
        return cells
    }
    
    
    @IBAction func editComplete(_ sender: Any) {
        
        let realm = try! Realm()
        
        try! realm.write {
            for msg in messages{
                if let cell = (allCells.compactMap{  ($0 as? TextEditcell)}.first){
                    msg.messageText = cell.textView.text
                }
                if let cell = (allCells.compactMap{  ($0 as? TimeEditCell)}.first){
                    msg.sendDate = cell.datePicker.date
                }
                if let cell = (allCells.compactMap{  ($0 as? DateEditCell)}.first){
                    
                }
            }
            
            chatVc.messageManager.reload()
            chatVc.tableView.reloadData()
            self.chatVc.allDeselct()
            self.navigationController?.presentingViewController?.dismiss(animated: true, completion: {
//                self.chatVc.allDeselct()
            })
            
        }
        
    }
    
    @objc func tapClose(_ sender: Any) {
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBOutlet var closeButton: UIBarButtonItem!{
        didSet{
            let button = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
            button.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
            button.snp.makeConstraints { (mk) in
                mk.width.height.equalTo(25)
            }
            closeButton.customView = button
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellKinds = getIndsWithMessageType()
        tableView.showsVerticalScrollIndicator = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellKinds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = cellKinds[indexPath.row]
        let msg = messages.first!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType)!
        
        if cellType == cellKind.TextCell.rawValue{
            guard let owner = msg.owner  else { return cell }
            (cell as? UserNameEditCell)?.nameLabel.text = owner.name
        }else if cellType == cellKind.DateCell.rawValue{
            
            
        }else if cellType == cellKind.TimeCell.rawValue{
            (cell as? TimeEditCell)?.time = msg.sendDate
        }else if cellType == cellKind.UserNameCell.rawValue{
            
        }
        return cell
    }
}
