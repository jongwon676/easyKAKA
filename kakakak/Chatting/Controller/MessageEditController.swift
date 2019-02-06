import UIKit
import SnapKit
import RealmSwift

class MessageEditController: UITableViewController {
    
    // messageManager
    weak var messageManager: MessageProcessor? // index를 넘기자.
    //
    
    // userNameEdit
    
    var isTimeEdit: Bool = false
    
    let userNameCellInfo : (headerName: String, reuseId: String) = ("이름","userNameEdit")
    let textCellInfo: (headerName: String,reuseId: String) = ("내용","textEdit")
    let imageCellInfo: (headerName: String,reuseId: String) = ("이미지","")
    let dateLineCellInfo: (headerName: String,reuseId: String) = ("날짜선","dateLineEdit")
    let recordCellInfo: (headerName: String, reuseId: String) = ("녹음 시간","recordCellEdit")
    let sendFailCellInfo: (headerName: String, reuseId: String) = ("전송 실패","sendFailEdit")
    let timeCellInfo: (headerName: String, reuseId: String) = ("","timeEditCell")
    
    
    var infos: [(headerName: String, reuseId: String)] = []
    
    
    // 순서가 messageProcessor부터 삽입
    
    
    
    var messageIndex: [Int]!{
        didSet{
            guard let idxes = messageIndex, let manager = messageManager else { return  }
            if !isTimeEdit{
                let idx = idxes[0]
                let msg = manager.getMessage(idx: idx)
                switch msg.type {
                case .date: infos = [dateLineCellInfo]
                case .text:
                    if msg.owner!.isMe {
                        infos = [userNameCellInfo,textCellInfo,sendFailCellInfo]
                    }else{
                        infos = [userNameCellInfo,textCellInfo]
                    }
                case .image:
                    if msg.owner!.isMe {
                        infos = [userNameCellInfo,imageCellInfo,sendFailCellInfo]
                    }else{
                        infos = [userNameCellInfo,imageCellInfo]
                    }
                case .record:
                    if msg.owner!.isMe {
                        infos = [userNameCellInfo,recordCellInfo,sendFailCellInfo]
                    }else{
                        infos = [userNameCellInfo,recordCellInfo]
                    }
                default: ()
                    
                }
            }else{
                infos = [timeCellInfo]
            }
        }
    }
    
    
    lazy var cancelButton: UIBarButtonItem = {
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        btn.snp.makeConstraints({ (mk) in
            mk.width.height.equalTo(25)
        })
        return UIBarButtonItem(customView: btn)
    }()
    
    lazy var okayButton: UIBarButtonItem = {
       let btn = UIBarButtonItem()
        btn.tintColor = UIColor.black
        btn.title = "완료"
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = #colorLiteral(red: 0.9370916486, green: 0.9369438291, blue: 0.9575446248, alpha: 1)
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = okayButton
        okayButton.target = self
        okayButton.action = #selector(okayButtonClicked)
        if isTimeEdit{
            navigationItem.title = "시간 수정"
        }else{
            navigationItem.title = "내용 수정"
        }
    }
    
    @objc func dismissController(){
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func okayButtonClicked(){
        
        var editContents = [MessageProcessor.EditContent?]()
        for section in (0 ..< infos.count){
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: section))
            if let editProtocol = cell as? EditCellProtocol{
                editContents.append(editProtocol.getEditContent())
            }
        }
        
        if !isTimeEdit{
            messageManager?.modifyMessage(row: messageIndex[0], contents: editContents.compactMap{$0} )
        }else{
            if let editContent = (editContents.compactMap{$0}).first{
                messageManager?.modifyTimes(rows: messageIndex, contents: editContent)
            }
            
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return infos.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 53
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        guard !isTimeEdit else {
            return nil
        }
        
        let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:53))
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = infos[section].headerName
        label.textColor = UIColor.black
        label.frame = CGRect(x: 18, y: 33, width: 300, height: 15)
        view.addSubview(label)
        view.backgroundColor = #colorLiteral(red: 0.9370916486, green: 0.9369438291, blue: 0.9575446248, alpha: 1)
        
        return view
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: infos[indexPath.section].reuseId)!
        
        if !isTimeEdit{
            (cell as? EditCellProtocol)?.configure(msg: messageManager!.getMessage(idx: messageIndex[0]))
        }else{
            guard let last = messageIndex.last else {
                return cell
            }
            (cell as? EditCellProtocol)?.configure(msg: messageManager!.getMessage(idx: last))
        }
        

        cell.selectionStyle = .none
        return cell
    }
}

protocol EditCellProtocol {
    func configure(msg: Message)
    func getEditContent() -> (MessageProcessor.EditContent)?
}
