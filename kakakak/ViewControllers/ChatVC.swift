import UIKit
import SnapKit
import InputBarAccessoryView
import RealmSwift

class ChatVC: UITableViewController{
    var realm = try! Realm()
    private weak var timer: Timer?
    var room: Room!
    lazy var messages = room.messages
    private var token: NotificationToken?
    
    var colors = [UIColor.red,.green,.black,.magenta,.orange,.blue]
    
    override var inputAccessoryView: UIView? {
        return inputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func getCurrentUser() -> User?{
        let customInputBar = inputBar as! GitHawkInputBar
        return customInputBar.selectedUser
    }
    
    
    open lazy var attachmentManager: AttachmentManager = { [unowned self] in
        let manager = AttachmentManager()
        manager.delegate = self
        return manager
    }()
    
    
    var inputBar: InputBarAccessoryView!{
        didSet{
            let customInput  = inputBar as! GitHawkInputBar
            customInput.clearUser()
            for user in room.users {
                customInput.addUser(user: user)
            }
        }
    }
    
    var guideLineIndex: IndexPath{
        get{
            for (idx,msg) in messages.enumerated(){
                if msg.type == .guide{
                    return IndexPath.row(row: idx)
                }
            }
            return IndexPath.row(row: 0)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        
        let clickY = sender.location(in: sender.view).y
        if sender.state != .recognized{
            return
        }
        
        var clickIndex = -1
        let pos = sender.location(in: sender.view)
        for idx in 0 ..< messages.count{
            if let cell = tableView.cellForRow(at: IndexPath.row(row: idx)){
                if cell.frame.contains(pos){
                    clickIndex = idx
                    break
                }
            }
        }
        
        var insertPosition = 0
        
        if clickIndex == -1{ insertPosition = messages.count }
        else{
            let rect = tableView.rectForRow(at: IndexPath.row(row: clickIndex))
            let upInsert = abs(rect.minY - clickY) < abs(rect.maxY - clickY)
            insertPosition = upInsert ? clickIndex : clickIndex + 1
        }
        
        let guideRow = guideLineIndex.row
        if guideRow == insertPosition || guideRow == insertPosition - 1{
            return
        }
        if guideRow < insertPosition {
            insertPosition -= 1
        }
        try! realm.write {
            messages.move(from: guideRow, to: insertPosition)
            tableView.reloadData()
            scrolToGuideLine()
        }
        
    }

    func makeDummyCells(){
        try! realm.write {
            realm.delete(messages)
        }
        
        var dummymsgs = [Message]()
        if messages.count < 2000{
            
            for idx in 0 ..< 20{
                var txt = ""
                for idx in  0 ..< arc4random_uniform(200) + 1{
                    txt += String(idx)
                }
                let msg = Message(owner: room.users[0], sendDate: room.currentDate, messageText: txt)
                dummymsgs.append(msg)
            }
            for idx in 0 ..< 20{
                let msg = Message.makeImageMessage(owner: room.users[0], sendDate: room.currentDate, imageUrl: "1547227315.3748941.jpg")
                dummymsgs.append(msg)
            }
            try! realm.write {
                let msg = Message(owner: nil, sendDate: Date(), messageText: "")
                msg.type = .guide
                messages.append(objectsIn: dummymsgs)
                messages.append(msg)
            }
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.reuseId)
        tableView.register(GuideLineCell.self, forCellReuseIdentifier: GuideLineCell.reuseId)
        tableView.register(ChattingImageCell.self, forCellReuseIdentifier: ChattingImageCell.reuseId)
        
        token = messages.observe{ [weak tableView] changes in
            print("observe")
            guard let tableView = tableView else { return }
            switch changes{
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
            case .error: break
            }
        }
        
        
//        makeDummyCells()
//        reload()
       
        
        
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger"), style: .plain, target: self, action: #selector(handleHamburger))
        
        inputBar = GitHawkInputBar()
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = UIKeyboardType.emailAddress
        inputBar.inputPlugins = [attachmentManager]
        tableView.tableFooterView = UIView()
//        self.tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.7427546382, green: 0.8191892505, blue: 0.8610599637, alpha: 1)
        self.navigationItem.title = Date.timeToStringSecondVersion(date: self.room.currentDate)
        tableView.reloadData()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        
    }
    
    deinit {
        token?.invalidate()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7427546382, green: 0.8191892505, blue: 0.8610599637, alpha: 1)
        self.tabBarController?.tabBar.isHidden = true
        
        
        

        
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                     repeats: true) {
                                        timer in
                                        try! self.realm.write {
                                            self.room.currentDate = self.room.currentDate.addingTimeInterval(1.0)
                                        }
                                        self.navigationItem.title = Date.timeToStringSecondVersion(date: self.room.currentDate)
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                print(indexPath.row)
        
        let msg = messages[indexPath.row]
        switch msg.type {
        case .guide:
            let cell = tableView.dequeueReusableCell(withIdentifier: GuideLineCell.reuseId) as! GuideLineCell
            
            return cell
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.reuseId) as! TextCell
            let users = (messages[indexPath.row].owner)!
            cell.incomming = !users.isMe
//            cell.backgroundColor = UIColor.red
            cell.configure(message: messages[indexPath.row])
//            cell.backgroundColor = colors[indexPath.row % colors.count]
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChattingImageCell.reuseId) as! ChattingImageCell
            let users = (messages[indexPath.row].owner)!
            cell.incomming = !users.isMe
            cell.configure(messages[indexPath.row])
            
            return cell
        default:
            return UITableViewCell()
            
        }
    }
    
}


extension ChatVC: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let selectedUser = getCurrentUser()
        if let currentUser = selectedUser{
            let message = Message(owner: currentUser, sendDate: Date(), messageText: text)
            message.sendDate = self.room.currentDate
            for user in room.users{
                if user.id != currentUser.id {
                    message.noReadUser.append(user)
                }
            }
            try! realm.write {
                messages.insert(message, at: guideLineIndex.row)
            }
            reload()
        }
    }
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {

    }
}


extension ChatVC: AttachmentManagerDelegate {
    
    
    // MARK: - AttachmentManagerDelegate
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        //        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func setAttachmentManager(active: Bool) {
        
        let topStackView = inputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
}

