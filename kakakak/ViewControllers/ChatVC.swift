import UIKit
import SnapKit
import InputBarAccessoryView
import RealmSwift
extension ChatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class ChatVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var realm = try! Realm()
    private weak var timer: Timer?
    var room: Room!
    lazy var messages = room.messages
    private var token: NotificationToken?
    let datePicker = UIDatePicker()
    
    var btn = UIButton(type: .custom)
    
    var tableView = UITableView()
    
    

    
    
    

private var keyboardManager = KeyboardManager()
    
    
    
//    override var inputAccessoryView: UIView? {
//        return inputBar
//    }
    
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
    
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
//        let clickY = sender.location(in: sender.view).y
        inputBar.inputTextView.resignFirstResponder()
//        if sender.state != .recognized{
//            return
//        }
//        var clickIndex = -1
//        let pos = sender.location(in: sender.view)
//        for idx in 0 ..< messages.count{
//
//            if let cell = tableView.cellForRow(at: IndexPath.row(row: idx)){
//                if cell.frame.contains(pos){
//                    clickIndex = idx
//                    break
//                }
//            }
//        }
//        var insertPosition = 0
//        if clickIndex == -1{ insertPosition = messages.count }
//        else{
//            let rect = tableView.rectForRow(at: IndexPath.row(row: clickIndex))
//            let upInsert = abs(rect.minY - clickY) < abs(rect.maxY - clickY)
//            insertPosition = upInsert ? clickIndex : clickIndex + 1
//        }
//        let guideRow = guideLineIndex.row
//        if guideRow == insertPosition || guideRow == insertPosition - 1{
//            return
//        }
//        if guideRow < insertPosition {
//            insertPosition -= 1
//        }
//        try! realm.write {
//            messages.move(from: guideRow, to: insertPosition)
//            tableView.reloadData()
//            scrolToGuideLine()
//        }
    }
    
    func registerCells(){
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.reuseId)
        tableView.register(GuideLineCell.self, forCellReuseIdentifier: GuideLineCell.reuseId)
        tableView.register(ChattingImageCell.self, forCellReuseIdentifier: ChattingImageCell.reuseId)
        tableView.register(DateCell.self, forCellReuseIdentifier: DateCell.reuseId)
        tableView.register(UserEnterCell.self, forCellReuseIdentifier: UserEnterCell.reuseId)
        tableView.register(UserExitCell.self, forCellReuseIdentifier: UserExitCell.reuseId)
    }
    
    
    var bottomConstraint: Constraint?
    
    func floatingButton(){
        btn.setTitle("floating", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 25
        btn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.layer.borderWidth = 3.0
        btn.addTarget(self,action: #selector(tap), for: .touchUpInside)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(btn)
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        let offset: CGFloat = 5.0
        var navHeight:CGFloat = 0
        if let nav = self.navigationController {
            navHeight = nav.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        }
        
        let btnWidth:CGFloat = 50
        let btnHeight:CGFloat = 50

        btn.frame = CGRect(x: UIScreen.main.bounds.width - btnWidth - offset, y: navHeight + offset, width: btnWidth, height: btnHeight)
    }
    
    @objc func tap(){
        inputBar.inputTextView.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        super.viewWillDisappear(animated)
        btn.removeFromSuperview()
    }
    

    
//    @objc func keyShow(){
//
//
//        bottomConstraint?.update(offset: -150)
//        UIView.animate(withDuration: 1) {
//                self.view.layoutIfNeeded()
//        }
//
////        tableView.scrollToRow(at: IndexPath.row(row: messages.count-1), at: .middle, animated: true)
//
//    }
//    @objc func keyHide(){
//
//        tableView.scrollToRow(at: IndexPath.row(row: messages.count-1), at: .middle, animated: true)
//    }
    

    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        
        
        
        self.view.addSubview(tableView)
        inputBar = GitHawkInputBar()
        view.addSubview(inputBar)
        
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            ])
        

        keyboardManager.bind(inputAccessoryView: inputBar)
        
        
        
        
        // Binding to the tableView will enabled interactive dismissal
        keyboardManager.bind(to: tableView)
        
        // Add some extra handling to manage content inset
        keyboardManager.on(event: .didChangeFrame) { [weak self] (notification) in
            let barHeight = self?.inputBar.bounds.height ?? 0
            self?.tableView.contentInset.bottom = barHeight + notification.endFrame.height
            self?.tableView.scrollIndicatorInsets.bottom = barHeight + notification.endFrame.height
            }.on(event: .didHide) { [weak self] _ in
                let barHeight = self?.inputBar.bounds.height ?? 0
                self?.tableView.contentInset.bottom = barHeight
                self?.tableView.scrollIndicatorInsets.bottom = barHeight
        }
        
        

        
       self.tableView.dataSource = self
        
        
        
        self.tableView.delegate = self
        

        
        registerCells()
        floatingButton()
        
//        token = messages.observe{ [weak tableView] changes in
//            print("observe")
//            guard let tableView = tableView else { return }
//            switch changes{
//            case .initial:
//                tableView.reloadData()
//            case .update(_, let deletions, let insertions, let updates):
//                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
//            case .error: break
//            }
//        }
        
        makeDummyCells()
        
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger"), style: .plain, target: self, action: #selector(handleHamburger))
        
        
        
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = UIKeyboardType.default
        
        inputBar.inputPlugins = [attachmentManager]
        
        
        tableView.keyboardDismissMode = .interactive
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.7427546382, green: 0.8191892505, blue: 0.8610599637, alpha: 1)
        self.navigationItem.title = Date.timeToStringSecondVersion(date: self.room.currentDate)
        tableView.reloadData()
        
    }
    
    
    deinit {
        print("chatvc deini")
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
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//                print(indexPath.row)
        let msg = messages[indexPath.row]
        
        switch msg.type {
        case .guide:
            let cell = tableView.dequeueReusableCell(withIdentifier: GuideLineCell.reuseId) as! GuideLineCell
            return cell
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.reuseId) as! TextCell
            let users = (msg.owner)!
            cell.incomming = !users.isMe
            cell.configure(message: msg)
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChattingImageCell.reuseId) as! ChattingImageCell
            let users = (msg.owner)!
            cell.incomming = !users.isMe
            cell.configure(msg)
            
            return cell
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateCell.reuseId) as! DateCell
            cell.configure(message: msg)
            return cell
        case .enter:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserEnterCell.reuseId) as! UserEnterCell
            cell.configure(message: msg)
            return cell
        case .exit:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserExitCell.reuseId) as! UserExitCell
            cell.configure(message: msg)
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
        inputBar.inputTextView.text = String()
    }
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        // Adjust content insets
        
        
        print(size)
        tableView.contentInset.bottom = size.height
    }
}


extension ChatVC: AttachmentManagerDelegate {
    
    
    // MARK: - AttachmentManagerDelegate
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
                setAttachmentManager(active: shouldBecomeVisible)
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

