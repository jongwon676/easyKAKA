import UIKit
import RealmSwift

class RoomAddVC:UIViewController, UITableViewDataSource,UITableViewDelegate{
    
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
    @IBAction func okayAction(_ sender: Any){
        if selectRows.count == 0{
            let alert = UIAlertController(title: nil, message: "등장인물을 선택해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        process()
    }
    
    var users = Preset.all()
    var selectRows: [IndexPath]{
        guard let indexPaths = tableView?.indexPathsForSelectedRows else { return  []}
        return indexPaths
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        tableView.allowsMultipleSelection = true
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

    @IBOutlet var bottomView: UIView! {
        didSet{
            bottomView
                .dropShadow(color: .gray, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 5, scale: true)
        }
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
    
    func process(){
        
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
                if selectedUsers.count == 0 { return }
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



