import UIKit
import RealmSwift
import ReplayKit

class ReplayController: UIViewController {
    
    var messageManager: MessageProcessor!
    
    var room: Room!
    
    
    
    lazy var tableView: UITableView = {
       let tableView = ChatTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNextMessage)))
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (mk) in
            mk.left.right.top.equalTo(self.view)
            mk.bottom.equalTo(self.middleView.snp.top)
        })
        
        return tableView
    }()
    
    lazy var middleView: MiddleView = {
       let middleView = MiddleView()
        middleView.textView.isEditable = false
        middleView.sendButton.setImage(UIImage(named: "enter"), for: .normal)
        self.view.addSubview(middleView)
        middleView.snp.makeConstraints({ (mk) in
            mk.left.right.equalTo(self.view)
            mk.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            mk.height.equalTo(40)
        })
        return middleView
    }()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let backgroundUrl = room.backgroundImageName, let backgroundImage = UIImage.loadImageFromName(backgroundUrl){
            
            let imageView = UIImageView(image: backgroundImage)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            
            tableView.backgroundView = UIImageView(image: backgroundImage)
            tableView.backgroundColor = nil
        }else if let colorHex = room.backgroundColorHex{
            tableView.backgroundColor = UIColor.init(hexString: colorHex)
            tableView.backgroundView = nil
            
        }else{
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7427546382, green: 0.8191892505, blue: 0.8610599637, alpha: 1)
            tableView.backgroundColor = #colorLiteral(red: 0.7427546382, green: 0.8191892505, blue: 0.8610599637, alpha: 1)
            tableView.backgroundView = nil
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bounces = false
        self.tableView.layer.removeAllAnimations()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backButtonClick)) 
        
        messageManager = MessageProcessor(room: room)
        messageManager.clear()
    
}
    
    @objc func backButtonClick(){
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func addNextMessage(){
        messageManager.update(tableView: self.tableView)
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return BaseChatCell.calc(message: messageManager.getMessage(idx: indexPath.row))
//    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return BaseChatCell.calc(message: messageManager.getMessage(idx: indexPath.row))
//    }
    
}

extension ReplayController: UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageManager.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = messageManager.getMessage(idx: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: msg.type.rawValue)
        cell?.selectionStyle = .none
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: msg.type.rawValue) as? BaseChatCell{
            cell.selectionStyle = .none
            cell.editMode = false
            (cell as? ChattingCellProtocol)?.configure(message: msg)
            return cell
        }
        return UITableViewCell()

    
    }
    
    
}
