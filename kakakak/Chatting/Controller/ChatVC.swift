import UIKit
import SnapKit
import RealmSwift


protocol CellConfigurator: class{
    static var reuseId: String { get }
    func configure(message: Message)
}

class ChatVC: UIViewController,UIGestureRecognizerDelegate{
    var realm = try! Realm()
    private weak var timer: Timer?
    
    @IBOutlet var childView: UIView!
    var room: Room!
    private var token: NotificationToken?
    var messageManager: MessageProcessor!
    var keyBoardFrame: CGRect? = nil
    let datePicker = UIDatePicker()
    var editButton = UIButton(type: .custom)
    let selectedImage = UIImage(named: "selected")
    let unSelectedImage = UIImage(named: "unSelected")
    
    
    var tableView: UITableView!
    var normalModeTableViewConstraint: Constraint?
    var editModeTableViewConstraint: Constraint?
    
    var bgType: BgType = .light


    
    lazy var editView:EditView = {
        let eview = EditView()
        eview.delegate = self
        self.view.addSubview(eview)
        eview.backgroundColor = UIColor.white
        return eview
    }()
    

    lazy var closeButton:UIBarButtonItem = {
        let btn = UIButton(type: .custom)
        
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        btn.snp.makeConstraints({ (mk) in
            mk.width.height.equalTo(25)
        })
        return UIBarButtonItem(customView: btn)
    }()
    
    lazy var backButton: UIBarButtonItem = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        btn.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        btn.snp.makeConstraints({ (mk) in
            mk.width.equalTo(32/3)
            mk.height.equalTo(55/3)
        })
        
        return UIBarButtonItem(customView: btn)
        
    }()
    
    lazy var fixedSpace:UIBarButtonItem =
        {
            let space =
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
            space.width = 20
            return space
            
    }()
    lazy var hamburgerButton: UIBarButtonItem = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        btn.addTarget(self, action: #selector(handleHamburger), for: .touchUpInside)
        
        btn.snp.makeConstraints({ (mk) in
            mk.width.equalTo(60/3)
            mk.height.equalTo(44/3)
        })
        return UIBarButtonItem(customView: btn)
    }()
    
    lazy var searchButton:UIBarButtonItem = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "searchCopy")!.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.snp.makeConstraints({ (mk) in
            mk.width.height.equalTo(53 / 3)
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
                editView.selectedMsgType = message.type
            }
        }
        editView.selectedChattingCount = cnt
        self.navigationItem.rightBarButtonItem = (cnt > 0) ? allDeselectButton : allSelectButton
        
    }
    
    
    var navLabel = UILabel()
    
    func needSetupNavTitle() {
        setNavTitle()
    }
    func setNavTitle(){
        
        let attributedString = NSMutableAttributedString()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 1
        
        
        
        
        
        
        attributedString.append(NSAttributedString(string: room.getRoomTitleName(),attributes: [
            .font: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 15.0)!
            ,.paragraphStyle:paragraph,
              .foregroundColor : bgType.getNavTitleColor()])
        )
        
        attributedString.append(NSAttributedString(string: room.getUserNumber(), attributes: [
            NSAttributedString.Key.foregroundColor : bgType.getNavUserCountColor()
            , .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
            ,.paragraphStyle:paragraph]
            )
        )
        
        if !(bottomController.mode == .capture) {
            
           
            attributedString.append(NSAttributedString(string:
                 Date.timeToString(date: self.room.currentDate), attributes:
                [NSAttributedString.Key.foregroundColor :  bgType.getNavUserCountColor(),.font: UIFont.systemFont(ofSize: 12, weight: .medium),.paragraphStyle:paragraph])
            )
        }

        navLabel.attributedText = attributedString
        navLabel.numberOfLines = 0
        navLabel.sizeToFit()
        if self.navigationItem.titleView == nil{
            self.navigationItem.titleView = navLabel
        }
        
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
        
        
        
        
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.title = "항목 선택"
        navigationItem.rightBarButtonItems = [allSelectButton]
        
        
        normalModeTableViewConstraint?.deactivate()
        editModeTableViewConstraint?.activate()
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
            hamburgerButton,fixedSpace, searchButton
        ]
        self.navigationItem.leftBarButtonItem = backButton
        
        

        normalModeTableViewConstraint?.activate()
        editModeTableViewConstraint?.deactivate()
    }
    
    var isEditMode: Bool = false{
        didSet{
            if isEditMode == false{
                editButton.isHidden = false
                allDeselct()
                setNoEditMode()
                setTimer()
                
            }else{
                editButton.isHidden = true
                setEditMode()
                setTimer()
            
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
    
    
  

    
    func floatingButton(){
        editButton.setImage(UIImage(named: "editButton"), for: .normal)
        editButton.addTarget(self,action: #selector(editButtonTap), for: .touchUpInside)
        view.addSubview(editButton)
//        if let window = UIApplication.shared.keyWindow {
//            window.addSubview(editButton)
//        }
    }
    
    
    fileprivate func addKeyboardObserver() {
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        token = room.observe({ [weak self] (change)  in
            guard let `self` = self else { return }
            switch change{
            case .change:
                self.setNavTitle()
                self.bottomController.timeInputView.date = self.room.currentDate
            case .error(_):
                ()
            case .deleted:
                ()
            }
        })
        
        tableView = (self.children[0] as! ChatBaseVC).tableView
        tableView.addGestureRecognizer(tableviewGestureRecog)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(KTextCell.self, forCellReuseIdentifier: KTextCell.reuseId)
        tableView.register(KImageCell.self, forCellReuseIdentifier: KImageCell.reuseId)
        tableView.register(KRecordCell.self, forCellReuseIdentifier: KRecordCell.reuseId)
        tableView.register(KDeleteMessageCell.self, forCellReuseIdentifier: KDeleteMessageCell.reuseId)
        tableView.register(KDateCell.self, forCellReuseIdentifier: KDateCell.reuseId)
        tableView.register(KInviteCell.self, forCellReuseIdentifier: KInviteCell.reuseId)
        tableView.register(KExitCell.self, forCellReuseIdentifier: KExitCell.reuseId)
        tableView.register(KCallMessageCell.self, forCellReuseIdentifier: KCallMessageCell.reuseId)
        view.addSubview(bottomController.view)
        
        
    
        
        tableView.snp.makeConstraints { (mk) in
            mk.left.right.top.equalTo(self.view)
            normalModeTableViewConstraint = mk.bottom.equalTo(self.bottomController.view.snp.top).constraint
            editModeTableViewConstraint = mk.bottom.equalTo(self.editView.snp.top).constraint
        }
        editModeTableViewConstraint?.deactivate()
        
        self.childView.snp.makeConstraints { (mk) in
            mk.left.right.bottom.top.equalTo(tableView)
        }
        
        
        
        if #available(iOS 11.0, *) {
            let dummyView = UIView()
            self.view.addSubview(dummyView)
            dummyView.backgroundColor = UIColor.white
            dummyView.snp.makeConstraints { (mk) in
                mk.left.right.equalTo(self.view)
                mk.bottom.equalTo(self.view.snp.bottom)
                mk.top.equalTo(self.bottomController.view.snp.bottom)
            }
        }
        

        

        messageManager = MessageProcessor(room: room)
        
        bottomController.messageManager = self.messageManager
        bottomController.timeInputView.room = room
        messageManager.vc = self
        messageManager.reload()
        
        
        
        //오전 12:56분에서 자꾸 버그 발생
        
        bottomController.view?.snp.makeConstraints({ (mk) in
            mk.left.right.equalTo(self.view)
            mk.bottom.equalTo(self.view.safeAreaLayoutGuide)
        })
        editView.snp.makeConstraints { (mk) in
            mk.left.right.bottom.equalTo(self.view.safeAreaLayoutGuide)
            mk.height.equalTo(60)
        }
        
        addKeyboardObserver()
        
        tableView.showsVerticalScrollIndicator = false
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
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1.0,
                                     repeats: true) { [weak self] _ in
                                        guard let `self` = self else { return }
                                        try! self.realm.write {
                                            self.room.currentDate = self.room.currentDate.addingTimeInterval(1.0)
                                        }
        }
        
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
        
        self.setNavTitle()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let colorIndex = room.backgroundcolorIndex
        tableView.backgroundColor = Style.allColors[colorIndex]
        tableView.backgroundView = nil
        navigationController?.navigationBar.barTintColor = Style.allColors[colorIndex]
        (bottomController.topView as? UserCollectionView)?.bgType = self.bgType
        bottomController.topView.backgroundColor = tableView.backgroundColor
        tabBarController?.tabBar.isHidden = true
        
        
        

        
        bgType = Style.getBgType(color: tableView.backgroundColor!)
        
        if let colorNav =   (self.navigationController as? ColorNavigationViewController){
            colorNav.setChattingNAv(color: tableView.backgroundColor ??  Style.allColors[0])
            colorNav.type = bgType
        }
        
        setTimer()
        setNavTitle()
        floatingButton()
        tableView.reloadData()

        
        
    
        if let navigationController = self.navigationController {
            let navigationBar = navigationController.navigationBar
            
            navigationBar.addSubview(navSpearator)
            navSpearator.frame = CGRect(x: 0, y: navigationBar.frame.size.height - 1, width: navigationBar.frame.size.width, height: 0.5)
            
        }
    }
    let navSpearator: UIView = {
       let sep = UIView()
        sep.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15)
        return sep
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        editButton.removeFromSuperview()
        ProfileImageCacher.shared.removeAll()
        navSpearator.removeFromSuperview()
        (self.navigationController as? ColorNavigationViewController)?.type = .dark
    }
    
    deinit {
        print("tableview deinit 됫다말구")
        NotificationCenter.default.removeObserver(self)
        token?.invalidate()
    }
}




extension ChatVC: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageManager?.messages.count ?? 0
    }    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let msg = messageManager.getMessage(idx: indexPath.row)
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: msg.getIdent())
        
      
        if let cell = (tableCell as? KExitCell) ?? (tableCell as? KCallMessageCell){
            cell.selectionStyle = .none
            cell.editMode = self.isEditMode
            (cell as? ChattingCellProtocol)?.configure(message: msg, bgType: bgType)
            cell.checkBoxImage.image = msg.isSelected ? UIImage(named: "selected") : UIImage(named: "unSelected")
            cell.bringSubviewToFront(cell.checkBoxImage)
            return cell
        }
        if let cell =
            (tableCell as? KTextCell) ??
            (tableCell as? KRecordCell) ??
            (tableCell as? KImageCell) ??
            (tableCell as? KDeleteMessageCell) ??
            (tableCell as? KDateCell)  ??
            (tableCell as? KInviteCell)
                {
            
            cell.selectionStyle = .none
            cell.editMode = self.isEditMode
            (cell as? ChattingCellProtocol)?.configure(message: msg, bgType: bgType)
            cell.checkBoxImage.image = msg.isSelected ? UIImage(named: "selected") : UIImage(named: "unSelected")
            cell.bringSubviewToFront(cell.checkBoxImage)
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let msg = messageManager.getMessage(idx: indexPath.row)
        if msg.type == .text{
            return KTextCell.height(message: msg)
        }else if msg.type == .image{
            return KImageCell.height(message: msg)
        }else if msg.type == .record{
            return KRecordCell.height(message: msg)
        }else if msg.type == .delete{
            return KDeleteMessageCell.height(message: msg)
        }else if msg.type == .date{
            return KDateCell.height(message: msg)
        }else if msg.type == .enter{
            return KInviteCell.height(message: msg)
        }else if msg.type == .exit{
            return KExitCell.height(message: msg)
        }else if msg.type == .call{
            return KCallMessageCell.height(message: msg)
        }
        else{
            return 50
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let msg = messageManager.getMessage(idx: indexPath.row)
        if msg.type == .text{
            return KTextCell.height(message: msg)
        }else if msg.type == .image{
            return KImageCell.height(message: msg)
        }else if msg.type == .record{
            return KRecordCell.height(message: msg)
        }else if msg.type == .delete{
            return KDeleteMessageCell.height(message: msg)
        }else if msg.type == .date{
            return KDateCell.height(message: msg)
        }else if msg.type == .enter{
            return KInviteCell.height(message: msg)
        }else if msg.type == .exit{
            return KExitCell.height(message: msg)
        }else if msg.type == .call{
            return KCallMessageCell.height(message: msg)
        }else{
            return 50
        }
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
            
            ($0 as? KBaseCell)?.checkBoxImage.image = selectedImage
        }
        refreshEdit()
    }
    @objc func allDeselct(){
        for message in messageManager.messages{
            message.isSelected = false
        }
        tableView.visibleCells.forEach{
            ($0 as? KBaseCell)?.checkBoxImage.image = unSelectedImage
        }
        refreshEdit()
    }
    
    @objc func handleTapEdit(_ gesture: UITapGestureRecognizer){
        let position = gesture.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: position){
            let newSelected = !messageManager.messages[indexPath.row].isSelected
            messageManager.messages[indexPath.row].isSelected = newSelected
            (tableView.cellForRow(at: indexPath) as? KBaseCell)?.checkBoxImage.image =
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

class CustomNavigationController: UINavigationController{
    
    var type: BgType = .dark{
        didSet{
            setNeedsStatusBarAppearanceUpdate()
            self.navigationBar.tintColor = type.barTintColor()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch type {
            case .dark: return .lightContent
            case .light: return .default
        }
    }
    
    
    
}
