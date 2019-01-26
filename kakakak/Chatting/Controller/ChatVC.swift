import UIKit
import SnapKit
import RealmSwift


protocol CellConfigurator: class{
    static var reuseId: String { get }
    func configure(message: Message)
}

class ChatVC: UIViewController{
    var realm = try! Realm()
    private weak var timer: Timer?
    var room: Room!
    private var token: NotificationToken?
    var messageManager: MessageProcessor!
    var keyBoardFrame: CGRect? = nil
    let datePicker = UIDatePicker()
    var btn = UIButton(type: .custom)
    let selectedImage = UIImage(named: "selected")
    let unSelectedImage = UIImage(named: "unSelected")
    
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
    
    func refreshEdit(){
        var cnt = 0
        for message in messageManager.messages{
            if message.isSelected{
                cnt = 1
                break
            }
        }
        self.navigationItem.rightBarButtonItem = (cnt > 0) ? allDeselectButton : allSelectButton
        
    }
    
    @objc func allSelect(){
        for message in messageManager.messages{
            message.isSelected = true
        }
        tableView.visibleCells.forEach{
            ($0 as? BaseChatCell)?.checkBoxImage.image = selectedImage
        }
        refreshEdit()
    }
    @objc func allDeselct(){
        for message in messageManager.messages{
            message.isSelected = false
        }
        tableView.visibleCells.forEach{
            ($0 as? BaseChatCell)?.checkBoxImage.image = unSelectedImage
        }
        refreshEdit()
    }
    
    
    func setEditMode(){
        
        
        self.tableView.allowsSelection = true
        self.tableView.allowsMultipleSelection = true
        bottomController.view.isHidden = true
        bottomController.keyboardHide()
        editView.isHidden = false
        tableView.reloadData()
        tableView.removeGestureRecognizer(tableviewGestureRecog)
        tableView.addGestureRecognizer(tableViewEditGestureRecog)
        
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
        tableView.removeGestureRecognizer(tableViewEditGestureRecog)
        
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

    lazy var tableviewGestureRecog = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    lazy var tableViewEditGestureRecog = UITapGestureRecognizer(target: self, action: #selector(handleTapEdit(_:)))
    
    @objc func handleTapEdit(_ gesture: UITapGestureRecognizer){
        let position = gesture.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: position){
            let newSelected = !messageManager.messages[indexPath.row].isSelected
            messageManager.messages[indexPath.row].isSelected = newSelected
            (tableView.cellForRow(at: indexPath) as? BaseChatCell)?.checkBoxImage.image =
                newSelected ? selectedImage : unSelectedImage
        }
        
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: msg.type.rawValue)
        cell?.selectionStyle = .none
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: msg.type.rawValue) as? BaseChatCell{
            cell.selectionStyle = .none
            cell.editMode = self.isEditMode
            (cell as? ChattingCellProtocol)?.configure(message: msg)
            cell.checkBoxImage.image = msg.isSelected ? UIImage(named: "selected") : UIImage(named: "unSelected")
            cell.bringSubviewToFront(cell.checkBoxImage)
            return cell
        }
        return UITableViewCell()
    }
   
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? BaseChatCell{
//            messageManager.messages[indexPath.row].isSelected = true
//            cell.checkBoxImage.image = selectedImage
//            refreshEdit()
//        }
//        print("select")
//
//    }
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) as? BaseChatCell{
//            messageManager.messages[indexPath.row].isSelected = false
//            cell.checkBoxImage.image = unSelectedImage
//            refreshEdit()
//        }
//        print("deselect")
//
//    }
}


