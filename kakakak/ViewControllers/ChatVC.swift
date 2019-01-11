import UIKit
import SnapKit
import InputBarAccessoryView
import RealmSwift

class ChatVC: UITableViewController{
    var realm = try! Realm()
    private weak var timer: Timer?
    var room: Room!
    
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
            for (idx,msg) in room.messages.enumerated(){
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
        for idx in 0 ..< room.messages.count{
            if let cell = tableView.cellForRow(at: IndexPath.row(row: idx)){
                if cell.frame.contains(pos){
                    clickIndex = idx
                    break
                }
            }
        }
        var insertPosition = 0        
        if clickIndex == -1{ insertPosition = room.messages.count }
        else{
            let rect = tableView.rectForRow(at: IndexPath.row(row: clickIndex))
            let upInsert = abs(rect.minY - clickY) < abs(rect.maxY - clickY)
            insertPosition = upInsert ? clickIndex : clickIndex + 1
        }
        
        let guideRow = guideLineIndex.row
        if guideRow == insertPosition || guideRow == insertPosition - 1{
            return
        }
        try! realm.write {
            let msg = Message(owner: nil, sendDate: Date(), messageText: "")
            msg.type = .guide
            room.messages.insert(msg, at: insertPosition)
            
            let guideIndices = (room.messages.indices).filter({ (idx) -> Bool in
                let msg = room.messages[idx]
                return msg.type == .guide
            })
            assert(guideIndices.count == 2)
            (guideRow < insertPosition)
                ? room.messages.remove(at: guideIndices[0])
                : room.messages.remove(at: guideIndices[1])
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("delegate \(indexPath.row) cell contain tap position")
    }
    var cacheHeight = [Date: CGFloat]()
    
    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        let msg = room.messages[indexPath.row]
    //
    //
    //
    //
    //        if let h = cacheHeight[msg.creationDate]{
    //            return h
    //        }
    //        switch msg.type {
    //        case .guide:
    //            let cell = tableView.dequeueReusableCell(withIdentifier: GuideLineCell.reuseId) as! GuideLineCell
    //            let height =  cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    //            cacheHeight[msg.creationDate] = height
    //            return height
    //
    //        default:
    //            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.reuseId) as! TextCell
    //            let users = (room.messages[indexPath.row].owner)!
    //            cell.incomming = !users.isMe
    //            cell.backgroundColor = UIColor.red
    //            cell.configure(message: room.messages[indexPath.row])
    //            cell.setNeedsLayout()
    //            cell.layoutIfNeeded()
    //
    //           let height =  cell.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    //            cacheHeight[msg.creationDate] = height
    //            return height
    //        }
    //
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for idx in 0 ..< room.messages.count{
            try! realm.write {
                let msg = room.messages[idx]
                msg.messageText = String(idx)
            }
        }
        //        tableView.rowHeight = UITableView.automaticDimension
        //        tableView.estimatedRowHeight = 300
        
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger"), style: .plain, target: self, action: #selector(handleHamburger))
        inputBar = GitHawkInputBar()
        
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = UIKeyboardType.emailAddress
        inputBar.inputPlugins = [attachmentManager]
        
        tableView.tableFooterView = UIView()
        
        self.tableView.keyboardDismissMode = .interactive
        
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.reuseId)
        tableView.register(GuideLineCell.self, forCellReuseIdentifier: GuideLineCell.reuseId)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.7427546382, green: 0.8191892505, blue: 0.8610599637, alpha: 1)
        self.navigationItem.title = Date.timeToStringSecondVersion(date: self.room.currentDate)
        
        reload()
        tableView.reloadData()
        
        if self.room.messages.count > 0 {
            tableView.scrollToRow(at: IndexPath.row(row: self.room.messages.count - 1), at: UITableView.ScrollPosition.bottom, animated: false)
        }
        
    }
    @objc func handleTimer(){
        self.navigationItem.title = Date.timeToStringSecondVersion(date: self.room.currentDate)
        try! self.realm.write{
            self.room.currentDate =
                self.room.currentDate.addingTimeInterval(1.0)
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7427546382, green: 0.8191892505, blue: 0.8610599637, alpha: 1)
        self.tabBarController?.tabBar.isHidden = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.1,
                                     repeats: true) {
                                        timer in
                                        try! self.realm.write {
                                            self.room.currentDate = self.room.currentDate.addingTimeInterval(1.0)
                                        }
                                        self.navigationItem.title = Date.timeToStringSecondVersion(date: self.room.currentDate)
        }
        //timer?.invalidate()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room.messages.count
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        print(indexPath.row)
        
        let msg = room.messages[indexPath.row]
        
        
        switch msg.type {
        case .guide:
            let cell = tableView.dequeueReusableCell(withIdentifier: GuideLineCell.reuseId) as! GuideLineCell
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.reuseId) as! TextCell
            let users = (room.messages[indexPath.row].owner)!
            cell.incomming = !users.isMe
            cell.backgroundColor = UIColor.red
            cell.configure(message: room.messages[indexPath.row])
            cell.backgroundColor = colors[indexPath.row % colors.count]
            
            
            
            return cell
            
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
            let insertIndex = guideLineIndex.row
            try! realm.write {
                room.messages.insert(message, at: insertIndex)
            }
            
            //            room.addMessage(message: message)
            //            UIImage.screenShot?.writeImage(imgName: "window.jpg")
            apply(index: insertIndex, type: .insert)
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

