import UIKit
import SnapKit

import RealmSwift


class ChatVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var realm = try! Realm()
    private weak var timer: Timer?
    var room: Room!
    lazy var messages = room.messages
    private var token: NotificationToken?
    var keyBoardFrame: CGRect? = nil
    

    let datePicker = UIDatePicker()
    
    
    
    var btn = UIButton(type: .custom)
    
    var tableView = UITableView()

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
        bottomController.keyboardHide()
        
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
//        inputBar.inputTextView.resignFirstResponder()
//        textField.resignFirstResponder()
    }
    
    
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        super.viewWillDisappear(animated)
        btn.removeFromSuperview()
    }
    
    let textField = UITextField()
    
    
    public let bottomController = KeyBoardAreaController()

    
    var first: Bool = true
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        
        addChild(bottomController)
        self.view.addSubview(bottomController.view)
        bottomController.didMove(toParent: self)
        bottomController.receiver = self
        bottomController.users = room.users
        bottomController.mode = .chatting
        
        
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
        
        tableView.tableFooterView = UIView()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.snp.makeConstraints { (mk) in
            mk.left.right.bottom.top.equalTo(self.view)
        }
        

        let bottomView = bottomController.view


        bottomView?.snp.makeConstraints({ (mk) in
            mk.left.right.bottom.equalTo(self.view)
        })

//
        registerCells()
        floatingButton()
        
        token = messages.observe{ [weak tableView] changes in

            guard let tableView = tableView else { return }
            switch changes{
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
            case .error: break
            }
        }
        
        makeDummyCells()
        
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger"), style: .plain, target: self, action: #selector(handleHamburger))
        tableView.keyboardDismissMode = .interactive
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.7427546382, green: 0.8191892505, blue: 0.8610599637, alpha: 1)
        self.navigationItem.title = Date.timeToStringSecondVersion(date: self.room.currentDate)
        tableView.reloadData()
        
    }
    
    
    deinit {
        print("chatvc deinit")
        NotificationCenter.default.removeObserver(self)
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


