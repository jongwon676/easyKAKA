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
    
    
    
    
    
    
    lazy var editView:EditView = {
        let eview = EditView()
        eview.delegate = self
        self.view.addSubview(eview)
        eview.backgroundColor = UIColor.black
        return eview
    }()
    
    lazy var hamburgerButton = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(handleHamburger))
    lazy var backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(handleBack))
    lazy var searchButton:UIBarButtonItem = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "search"), for: .normal)
        btn.snp.makeConstraints({ (mk) in
            mk.width.height.equalTo(25)
        })
        return UIBarButtonItem(customView: btn)
    }()
    
    lazy var allSelectButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "전체 선택", style: .plain, target: self, action: #selector(allSelect))
        btn.tintColor = UIColor.black
        return btn
    }()
    lazy var allDeselectButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "선택 해제", style: .plain, target: self, action: #selector(allDeselct))
        btn.tintColor = UIColor.black
        btn.title = "전체 해제"
        return btn
    }()
    
    func updateVisibleCells(selected: Bool){
        guard let visibleRows = tableView.indexPathsForVisibleRows else {
            return
        }

        tableView.reloadRows(at: visibleRows, with: .none)
    }
    
    @objc func allSelect(){
        for idx in 0 ..< tableView.numberOfRows(inSection: 0){
            tableView.selectRow(at: IndexPath.row(row: idx), animated: false, scrollPosition: .none)
        }
//        updateVisibleCells()
        
    }
    @objc func allDeselct(){
        for idx in 0 ..< tableView.numberOfRows(inSection: 0){
            tableView.deselectRow(at: IndexPath.row(row: idx), animated: false)
        }
//        updateVisibleCells()
    }
    
    
    func setEditMode(){
        
        
        self.tableView.allowsSelection = true
        self.tableView.allowsMultipleSelection = true
        bottomController.view.isHidden = true
        bottomController.keyboardHide()
        editView.isHidden = false
        tableView.reloadData()
        tableView.removeGestureRecognizer(tableviewGestureRecog)
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        navigationItem.title = "항목 선택"
        navigationItem.rightBarButtonItem = allSelectButton
    }
    
    func setNoEditMode(){
        self.tableView.allowsSelection = false
        self.tableView.allowsMultipleSelection = false
        excuteCancel()
        bottomController.view.isHidden = false
        editView.isHidden = true
        tableView.reloadData()
        tableView.addGestureRecognizer(tableviewGestureRecog)
        navigationController?.navigationBar.barTintColor = tableView.backgroundColor
        self.navigationItem.rightBarButtonItems = [
            hamburgerButton, searchButton
        ]
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    var isEditMode: Bool = false{
        didSet{
            if isEditMode == false{
                allDeselct()
                setNoEditMode()
            }else{
                setEditMode()
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
    @objc func handleBack(){
        self.navigationController?.popViewController(animated: true)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer){

        guard !isEditMode else {
            return
        }
         bottomController.keyboardHide() 
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
            print("\(indexPath)" + " \(cell.isSelected)")
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
        if let cell = tableView.cellForRow(at: indexPath) as? BaseChatCell{
            cell.checkBoxImage.image = UIImage(named: "selected")
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? BaseChatCell{
            cell.checkBoxImage.image = UIImage(named: "unSelected")
        }
        
        
    }
}


