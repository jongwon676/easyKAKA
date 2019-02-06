import UIKit
import SnapKit
import RealmSwift

class MessageEditController: UITableViewController {
    
    // messageManager
    weak var messageManager: MessageProcessor? // index를 넘기자.
    //
    
    // userNameEdit
    let userNameCellInfo : (headerName: String, reuseId: String) = ("이름","userNameEdit")
    let textCellInfo: (headerName: String,reuseId: String) = ("내용","textEdit")
    let imageCellInfo: (headerName: String,reuseId: String) = ("이미지","")
    let dateLineCellInfo: (headerName: String,reuseId: String) = ("날짜선","dateLineEdit")
    let recordCellInfo: (headerName: String, reuseId: String) = ("녹음 시간","recordCellEdit")
    let sendFailCellInfo: (headerName: String, reuseId: String) = ("전송 실패","sendFailEdit")
    
    var infos: [(headerName: String, reuseId: String)] = []
    
    
    // 순서가 messageProcessor부터 삽입
    
    var messageIndex: Int!{
        didSet{
            guard let idx = messageIndex, let manager = messageManager else { return  }
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
        }
    }
    //
    
    //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .lightGray
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return infos.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.snp.makeConstraints { (mk) in
            mk.height.equalTo(53)
        }
        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints { (mk) in
            mk.left.equalTo(view).offset(18)
            mk.bottom.equalTo(view).offset(10)
        }
        label.text = infos[section].headerName
        view.backgroundColor = .lightGray
        return view
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: infos[indexPath.section].reuseId)!
        (cell as? EditCellProtocol)?.configure(msg: messageManager!.getMessage(idx: messageIndex))
        return cell
    }
}
protocol EditCellProtocol {
    func configure(msg: Message)
}
