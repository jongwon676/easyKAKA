import UIKit
import SnapKit
import RealmSwift

class ChatVC: UIViewController{
    var realm = try! Realm()
    private weak var timer: Timer?
    var room: Room!
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
                tableView.reloadData()
                tableView.removeGestureRecognizer(tableviewGestureRecog)
            }else{
                self.tableView.allowsSelection = false
                self.tableView.allowsMultipleSelection = false
                
                excuteCancel()
                bottomController.view.isHidden = false
                editView.isHidden = true
                tableView.reloadData()
                tableView.addGestureRecognizer(tableviewGestureRecog)
                
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

    let tableviewGestureRecog = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    lazy var tableView:ChatTableView = {
        let table = ChatTableView()
        table.dataSource = self
        table.delegate = self
        table.addGestureRecognizer(tableviewGestureRecog)
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
        btn.setImage(UIImage(named: "editButton"), for: .normal)
        btn.addTarget(self,action: #selector(editButtonTap), for: .touchUpInside)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(btn)
        }
    }
    
    @objc func editButtonTap(){ isEditMode = !isEditMode }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        self.view.addSubview(tableView)
        self.view.addSubview(bottomController.view)
//        self.makeDummyCells()
        messageManager = MessageProcessor(room: room)
        messageManager.reload()
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
        
            tableView.reloadData()
            isEditMode = false
    }
    override func viewWillLayoutSubviews() {
        
        let offset: CGFloat = 5.0
        var navHeight: CGFloat = 0
        if let nav = self.navigationController {
            navHeight = nav.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        }
        let btnWidth:CGFloat = 259 / 3
        let btnHeight:CGFloat = 114 / 3
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
        floatingButton()
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        btn.removeFromSuperview()
    }
    
    deinit {
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
        switch msg.type {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.reuseId) as! TextCell
            cell.selectionStyle = .none
            cell.editMode = self.isEditMode
            cell.configure(message: msg)
            
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChattingImageCell.reuseId) as! ChattingImageCell
            cell.selectionStyle = .none
            cell.editMode = self.isEditMode
            cell.configure(msg)
            
            return cell
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateCell.reuseId) as! DateCell
            cell.selectionStyle = .none
            cell.editMode = self.isEditMode
            cell.configure(message: msg)
            
            return cell
        case .enter:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserEnterCell.reuseId) as! UserEnterCell
            cell.selectionStyle = .none
            cell.editMode = self.isEditMode
            cell.configure(message: msg)
            
            return cell
        case .exit:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserExitCell.reuseId) as! UserExitCell
            cell.selectionStyle = .none
            cell.editMode = self.isEditMode
            cell.configure(message: msg)
            
            return cell
        case .voice:
            let cell = tableView.dequeueReusableCell(withIdentifier: VoiceCell.reuseId) as! VoiceCell
            cell.selectionStyle = .none
            cell.editMode = self.isEditMode
            cell.configure(message: msg)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}


