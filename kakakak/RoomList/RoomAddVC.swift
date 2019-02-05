import UIKit
import RealmSwift

class RoomAddVC:UIViewController, UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet var titleLabel: UILabel!
    
    enum ControllerType {
        case invite
        case exit
        case create
    }
    
    weak var messageManager: MessageProcessor?
    
    func veryfiy() -> Bool{
        
        var okay = true
        var alertTitle = ""
        
        switch self.type {
        case .create:
            okay = selectRows.count >= 2
            alertTitle = "채팅방을 만들려면 2명이상의 등장인물이 필요합니다"
        case .invite:
            okay = selectRows.count >= 1
            alertTitle = "초대할 친구를 선택해주세요"
        case .exit:
            okay = selectRows.count == 1
            alertTitle = "퇴장할 친구를 선택해주세요"
        }
        
        if !okay{
            let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        return okay
    }
    
    var type: ControllerType = .create
        
        
        
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var buttonTitle: String = "생성하기"
    @IBAction func dismiss(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setUpTitleButton(){
        let string = buttonTitle + " " + String(selectRows.count)
        makeButton.setTitle(string, for: .normal)
    }
    
    @IBOutlet var tableView: UITableView!
    
    
    @IBOutlet var makeButton: GradientButton!{
        didSet{
            setUpTitleButton()
        }
    }
    
    @objc func okayAction(_ sender: Any){
        
        process()
    }
    
    var users: List<Preset>!
    var includeId = Set<String>()
    var excludeId = Set<String>()
    var canInviteUser = List<User>()
    var selectRows: [IndexPath]{
        guard let indexPaths = tableView?.indexPathsForSelectedRows else { return  []}
        return indexPaths
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users = Preset.all(include: includeId, exclude: excludeId, type: type)
        switch type {
            case .create:
                titleLabel.text = "채팅방 생성"
                tableView.allowsMultipleSelection = true
            case .invite:
                titleLabel.text = "친구 초대"
                tableView.allowsMultipleSelection = true
            
            case .exit:
                titleLabel.text = "친구 퇴장"
                tableView.allowsMultipleSelection = false
        }
        
        self.makeButton.addTarget(self, action: #selector(okayAction), for: .touchUpInside)
        tableView.separatorStyle = .none
        tableView.sectionIndexBackgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
//        return 0
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    @IBOutlet var bottomView: UIView!
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomView
            .dropShadow(color: .gray, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 5, scale: true)
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let first = tableView.indexPathsForSelectedRows?.filter{
            $0 == indexPath
        }.first
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        cell.contentView.backgroundColor = UIColor.clear
        
        if first == nil{
            cell.checked = false
        }else{
            cell.checked = true
        }
        cell.selectionStyle = .none
        cell.user = users[indexPath.row]
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        setUpTitleButton()
        if let cell = tableView.cellForRow(at: indexPath) as? UserCell{
            cell.checked =  true
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        setUpTitleButton()
        if let cell = tableView.cellForRow(at: indexPath) as? UserCell{
            cell.checked =  false
        }
    }
}
extension RoomAddVC{
    
    
    func createProcess(){
        let selectedUsers = selectRows.map { return users[$0.row] }
        let checkMeAlert = UIAlertController(title: nil, message: "나를 선택해주세요.", preferredStyle: .actionSheet)
        let inviteAlert = UIAlertController(title: nil, message: "초대자를 선택해주세요.",preferredStyle: .actionSheet)
        
        var me: Preset?
        
        for user in selectedUsers{
            inviteAlert.addAction(UIAlertAction(title: user.name, style: .default, handler: { (action) in
                guard let me = me else { return  }
                self.makeRoom(me: me, inviter: user, users: selectedUsers)
                self.dismiss(animated: true, completion: nil)
            }))
        }
        
        for user in selectedUsers{
            checkMeAlert.addAction(UIAlertAction(title: user.name, style: .default, handler: { (action) in
                
                me = user
                
                if selectedUsers.count <= 2{
                    self.makeRoom(me: user, inviter: nil, users: selectedUsers)
                    self.dismiss(animated: true, completion: nil)
                    return
                }else{
                    self.present(inviteAlert, animated: true, completion: nil)
                }
            }))
        }
        present(checkMeAlert, animated: true)
    }
    
    func process(){
        
        guard self.veryfiy() else { return }
        switch type {
        case .create:
            createProcess()
        case .exit:
            exitProcess()
        case .invite:
            inviteProcess()
            
        }
    }
    func inviteProcess(){
        
        
        let invitedPreset = selectRows.map{ return users[$0.row]}
//        var invitePresetId: String = ""
        //
        //inviterCand삽입해줘야됨
        
        
        
        let alert = UIAlertController(title: "초대자를 선택해주세요.", message: nil, preferredStyle: .actionSheet)
        
        for inviteUserCand in canInviteUser{
            alert.addAction(UIAlertAction(title: inviteUserCand.name, style: .default, handler: { (action) in
                self.messageManager?.enterUser(inviter: inviteUserCand, invitedUsers: invitedPreset)
                self.dismiss(animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func exitProcess(){
        guard let exitUser = (selectRows.map { return users[$0.row] }).first else {
            return
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        messageManager?.eixtUser(presetId: exitUser.id)
    }
    
    
    func makeRoom(me: Preset, inviter: Preset?, users: [Preset]){
        let roomMessages = List<Message>()
        let roomUsers = List<User>()
        for user in users{
            roomUsers.append(User(preset: user, isMe: user.id == me.id))
        }
        roomMessages.append(Message.makeDateMessage())
        if let inviter = inviter{
            let invitedUser = List<User>()
            for user in users{
                if user != inviter{
                    invitedUser.append(User(preset: user, isMe: user.id == me.id))
                }
            }
            roomMessages.append(Message.makeEnterMessage(from: User(preset: inviter, isMe: inviter.id == me.id), to: invitedUser))
        }
        Room.add(users: roomUsers, messages: roomMessages)
    }
}



