import UIKit
import RealmSwift

class RoomAddVC:UITableViewController{
    
    @IBAction func cancelAction(_ sender: Any) {
        if let rootVC = self.presentingViewController{
            rootVC.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func okayAction(_ sender: Any){
        
        if let rootVC = self.presentingViewController{
            rootVC.dismiss(animated: true, completion: nil)
        }
        
    }
    var users = Preset.all()
    var selectRows: [IndexPath]{
        guard let indexPaths = tableView.indexPathsForSelectedRows else { return  []}
        return indexPaths
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.allowsMultipleSelection = true
        tableView.sectionIndexBackgroundColor = .clear
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "등장인물"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        cell.user = users[indexPath.row]
        if selectRows.contains(indexPath){
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            
            cell.accessoryType = .checkmark
        }
        //        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .none
        }
    }
}
extension RoomAddVC{
    
    func process(){
        
        let selectedUsers = selectRows.map { return users[$0.row] }
        let checkMeAlert = UIAlertController(title: nil, message: "나를 선택해주세요.", preferredStyle: .actionSheet)
        let inviteAlert = UIAlertController(title: nil, message: "초대자를 선택해주세요.",preferredStyle: .actionSheet)
        
        
        var me: Preset? = nil
        var inviter: Preset? = nil
        
        for user in selectedUsers{
            checkMeAlert.addAction(UIAlertAction(title: user.name, style: .default))
        }
        
        for user in selectedUsers{
            checkMeAlert.addAction(UIAlertAction(title: user.name, style: .default, handler: { (action) in
                inviter = user
            }))
        }
        
        
        
        
        
        
        present(checkMeAlert, animated: true) {
            guard let me = me else { return }
            if selectedUsers.count == 1{
                self.makeRoom(me: me, inviter: nil, users: [me])
                return
            }
            self.present(inviteAlert, animated: true, completion: {
                guard let inviter = inviter else { return }
                
            })
        }
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
        
        roomMessages.append(Message.makeGuideMessage())
        Room.add(users: roomUsers, messages: roomMessages)
    }
}
