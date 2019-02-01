import UIKit
import SnapKit
import RealmSwift
import CBFlashyTabBarController

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
    var editButton = UIButton(type: .custom)
    let selectedImage = UIImage(named: "selected")
    let unSelectedImage = UIImage(named: "unSelected")
    var cacheHeight = [String: CGFloat]()
    
    lazy var editView:EditView = {
        let eview = EditView()
        eview.delegate = self
        self.view.addSubview(eview)
        eview.backgroundColor = UIColor.white
        return eview
    }()
    
    lazy var hamburgerButton = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(handleHamburger))
    lazy var backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(handleBack))
    lazy var closeButton:UIBarButtonItem = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        btn.snp.makeConstraints({ (mk) in
            mk.width.height.equalTo(25)
        })
        return UIBarButtonItem(customView: btn)
    }()
    
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
    
    
    func refreshEdit(){
        var cnt = 0
        for message in messageManager.messages{
            if message.isSelected{
                cnt += 1
            }
        }
        editView.selectedChattingCount = cnt
        self.navigationItem.rightBarButtonItem = (cnt > 0) ? allDeselectButton : allSelectButton
        
    }
    
    
    
    
    func setEditMode(){
        
        timer?.invalidate()
        self.tableView.allowsSelection = true
        self.tableView.allowsMultipleSelection = true
        bottomController.view.isHidden = true
        bottomController.keyboardHide()
        editView.isHidden = false
        tableView.reloadData()
        tableView.removeGestureRecognizer(tableviewGestureRecog)
        tableView.addGestureRecognizer(tableViewEditGestureRecog)
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.title = "항목 선택"
        navigationItem.rightBarButtonItems = [allSelectButton]
        
        
        
    }
    func setNavTitle(){
        let label = UILabel()
        var attributedString = NSMutableAttributedString()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        
        attributedString.append(NSAttributedString(string: room.getRoomTitleName(),attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)
            ,.paragraphStyle:paragraph])
        )
        
        attributedString.append(NSAttributedString(string: room.getUserNumber(), attributes: [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3319326043, green: 0.3760439456, blue: 0.4094469249, alpha: 1)
            , .font: UIFont.systemFont(ofSize: 18)
            ,.paragraphStyle:paragraph]
            )
        )
        
        attributedString.append(NSAttributedString(string:
            "대화방 시간 " + Date.timeToString(date: self.room.currentDate), attributes:
            [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.4180841446, green: 0.4661870003, blue: 0.5037575364, alpha: 1),.font: UIFont.systemFont(ofSize: 14),.paragraphStyle:paragraph])
        )
        
        label.attributedText = attributedString
        label.numberOfLines = 2
        self.navigationItem.titleView = label
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
        
        setTimer()
    }
    
    var isEditMode: Bool = false{
        didSet{
            if isEditMode == false{
                editButton.isHidden = false
                allDeselct()
                setNoEditMode()
            }else{
                editButton.isHidden = true
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
    
    @IBOutlet var tableView: UITableView! {
        didSet{
            tableView.addGestureRecognizer(tableviewGestureRecog)
            tableView.backgroundColor = UIColor.red
            
    }
    }
    
//    lazy var tableView:ChatTableView = {
//        let table = ChatTableView()
//        table.dataSource = self
//        table.delegate = self
//        table.addGestureRecognizer(tableviewGestureRecog)
//        return table
//    }()
    
    func floatingButton(){
        editButton.setImage(UIImage(named: "editButton"), for: .normal)
        editButton.addTarget(self,action: #selector(editButtonTap), for: .touchUpInside)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(editButton)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        self.view.addSubview(bottomController.view)
        
//        self.makeDummyCells()
        
        messageManager = MessageProcessor(room: room)
        bottomController.messageManager = self.messageManager
        messageManager.vc = self
        
        messageManager.reload()
        tableView.snp.makeConstraints { (mk) in
            mk.left.right.top.equalTo(self.view)
//            mk.bottom.equalTo(self.view.safeAreaLayoutGuide)
            mk.bottom.equalTo(self.bottomController.view.snp.top)
        }
        bottomController.view?.snp.makeConstraints({ (mk) in
            mk.left.right.equalTo(self.view)
            mk.bottom.equalTo(self.view.safeAreaLayoutGuide)
        })
        editView.snp.makeConstraints { (mk) in
            mk.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
            mk.height.equalTo(60)
        }
        
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
        let btnWidth: CGFloat = 259 / 3
        let btnHeight: CGFloat = 114 / 3
        editButton.frame = CGRect(x: UIScreen.main.bounds.width - btnWidth - offset, y: navHeight + offset, width: btnWidth, height: btnHeight)
        
    }
    func setTimer(){
        
        timer = Timer.scheduledTimer(withTimeInterval: 60.0,
                                     repeats: true) { [weak self] _ in
                                        guard let `self` = self else { return }
                                        try! self.realm.write {
                                            self.room.currentDate = self.room.currentDate.addingTimeInterval(60.0)
                                        }
                                        self.setNavTitle()
        }
        self.setNavTitle()
        
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

        setTimer()
        floatingButton()
        
    
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        editButton.removeFromSuperview()
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
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let msg = messageManager.messages[indexPath.row]
        if msg.type == .text{
            return cacheHeight[msg.messageText] ??   UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        let msg = messageManager.getMessage(idx: indexPath.row)
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "textMe") as? TextMe
        cell2?.configure(message: msg)
        return cell2!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: msg.type.rawValue)
        cell?.selectionStyle = .none
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: msg.type.rawValue) as? BaseChatCell{
            cell.selectionStyle = .none
            cell.editMode = self.isEditMode
            (cell as? ChattingCellProtocol)?.configure(message: msg)
            cell.checkBoxImage.image = msg.isSelected ? UIImage(named: "selected") : UIImage(named: "unSelected")
            cell.bringSubviewToFront(cell.checkBoxImage)
            if (cell as? TextCell) != nil{
                cacheHeight[msg.messageText] = cell.frame.height
            }
            return cell
        }
        return UITableViewCell()
    }
    
}


//@objc function
extension ChatVC{
    @objc func handleClose(){
        self.isEditMode = false
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
    
    @objc func handleTapEdit(_ gesture: UITapGestureRecognizer){
        let position = gesture.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: position){
            let newSelected = !messageManager.messages[indexPath.row].isSelected
            messageManager.messages[indexPath.row].isSelected = newSelected
            (tableView.cellForRow(at: indexPath) as? BaseChatCell)?.checkBoxImage.image =
                newSelected ? selectedImage : unSelectedImage
        }
        refreshEdit()
        
    }
    @objc func handleBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        
        guard !isEditMode else {
            return
        }
        bottomController.keyboardHide()
    }
    @objc func editButtonTap(){ isEditMode = true }
}
