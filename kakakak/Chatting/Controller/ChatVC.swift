import UIKit
import SnapKit

import RealmSwift


class ChatVC: UIViewController{
    
    var realm = try! Realm()
    private weak var timer: Timer?
    var room: Room!
//    lazy var messages = Array(room.messages)
    private var token: NotificationToken?
    var messageManager: MessageProcessor!
    
    
    
    var keyBoardFrame: CGRect? = nil
    let datePicker = UIDatePicker()
    var btn = UIButton(type: .custom)
    
    var selectedRows = Set<IndexPath>()
    lazy var editView:EditView = {
        let eview = EditView()
        eview.delegate = self
        self.view.addSubview(eview)
        eview.backgroundColor = UIColor.black
        
        return eview
    }()
    
    var isEditMode: Bool = false{
        didSet{
            if isEditMode == true{
                self.tableView.allowsSelection = true
                self.tableView.allowsMultipleSelection = true
                bottomController.view.isHidden = true
                bottomController.keyboardHide()
                selectedRows.removeAll()
                editView.isHidden = false
            }else{
                self.tableView.allowsSelection = false
                self.tableView.allowsMultipleSelection = false
                excuteCancel()
                bottomController.view.isHidden = false
                editView.isHidden = true
            }
        }
    }
    
    public lazy var bottomController: KeyBoardAreaController = {
        let controller = KeyBoardAreaController()
        addChild(controller)
        
        controller.didMove(toParent: self)
        
        controller.receiver = self
        controller.users = room.users
        controller.mode = .chatting
        
        
        return controller
    }()

    
    lazy var tableView:ChatTableView = {
        let table = ChatTableView()
        
        table.dataSource = self
        table.delegate = self
        
        
        table.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        return table
        
    }()

 
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        if isEditMode{
            if sender.state == .ended , let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)){
                if selectedRows.contains(indexPath){
                    tableView.deselectRow(at: indexPath, animated: false)
                    selectedRows.remove(indexPath)
                }else{
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    selectedRows.insert(indexPath)
                }
            }
        }else{
            bottomController.keyboardHide()
        }
    }
    
    
    func floatingButton(){
        btn.setTitle("floating", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 25
        btn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.layer.borderWidth = 3.0
        btn.addTarget(self,action: #selector(editButtonTap), for: .touchUpInside)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(btn)
        }
    }
    
    

    
    
    @objc func editButtonTap(){ isEditMode = !isEditMode }
    

    
    // MARK: viewcontroller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.view.addSubview(bottomController.view)
        self.makeDummyCells()
        
        
        messageManager = MessageProcessor(room: room)
        
        messageManager.reload()
        
        for message in messageManager.messages{
            if message.isFirstMessage{
                print("isFirst message\(message)")
                
            }
            if message.isLastMessage{
                print("isLast message\(message)")
            }
        }
        
        
        tableView.snp.makeConstraints { (mk) in
            mk.left.right.bottom.top.equalTo(self.view)
        }
        
        
        bottomController.view?.snp.makeConstraints({ (mk) in
            mk.left.right.bottom.equalTo(self.view)
        })
        
        editView.snp.makeConstraints { (mk) in
            mk.left.right.bottom.equalTo(self.view)
            mk.height.equalTo(40)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger"), style: .plain, target: self, action: #selector(handleHamburger))
        
        self.navigationItem.title = Date.timeToStringSecondVersion(date: self.room.currentDate)

        bottomController.middleView.becomeFirstResponder()
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(calcKeyBoardFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)

    

        floatingButton()
        
        tableView.reloadData()
        
        isEditMode = false
    }
    override func viewWillLayoutSubviews() {
        //        bottomController.textView.resignFirstResponder()
        let offset: CGFloat = 5.0
        var navHeight:CGFloat = 0
        if let nav = self.navigationController {
            navHeight = nav.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        }
        
        
        let btnWidth:CGFloat = 50
        let btnHeight:CGFloat = 50
        
        btn.frame = CGRect(x: UIScreen.main.bounds.width - btnWidth - offset, y: navHeight + offset, width: btnWidth, height: btnHeight)
    }
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
        
        
        self.tabBarController?.tabBar.isHidden = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                     repeats: true) {
                                        timer in
                                        try! self.realm.write {
                                            self.room.currentDate = self.room.currentDate.addingTimeInterval(1.0)
                                        }
                                        self.navigationItem.title = Date.timeToStringSecondVersion(date: self.room.currentDate)
        }
//        self.updateTimer = Timer.scheduledTimer(timeInterval:1.0, target: self, selector: Selector(("updateFunction")), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustInsetForKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(adjustInsetForKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        btn.removeFromSuperview()
    }
    
    
    deinit {
        print("chatvc deinit")
        NotificationCenter.default.removeObserver(self)
        token?.invalidate()
        
    }
}



extension ChatVC: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageManager?.messages.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = messageManager.getMessage(idx: indexPath.row)
        print("\(indexPath.row) \(msg.isFirstMessage) \(msg.isLastMessage)")
        switch msg.type {
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
        case .voice:
            let cell = tableView.dequeueReusableCell(withIdentifier: VoiceCell.reuseId) as! VoiceCell
            cell.configure(message: msg)
            return cell
        default:
            return UITableViewCell()
            
        }
    }

    
}


