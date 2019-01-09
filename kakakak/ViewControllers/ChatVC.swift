import UIKit
import SnapKit
import InputBarAccessoryView
import RealmSwift

class ChatVC: UITableViewController{
    var realm = try! Realm()
    var timer: Timer?
    var room: Room!

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        inputBar = GitHawkInputBar()
        
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = UIKeyboardType.emailAddress
        inputBar.inputPlugins = [attachmentManager]
        
        tableView.tableFooterView = UIView()
        
        self.tableView.keyboardDismissMode = .interactive
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.reuseId)
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
        print(self.room.currentDate)
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
        
        //        tableView.frame = view.bounds
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
    }
    
    
    
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.reuseId) as! TextCell
        let users = (room.messages[indexPath.row].owner)!
        cell.incomming = !users.isMe
        cell.configure(message: room.messages[indexPath.row])
        return cell
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
            room.addMessage(message: message)
            apply(index: room.messages.count - 1, type: .insert)
        }
    }
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        // Adjust content insets
        //                tableView.contentInset.bottom = size.height
        //        let msgCount = room.messages.count
        //        if msgCount - 1 > 0 {
        //            let path = IndexPath(row: msgCount - 1, section: 0)
        //            tableView.scrollToRow(at: path, at: UITableView.ScrollPosition.bottom, animated: true)
        //        }
        
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

