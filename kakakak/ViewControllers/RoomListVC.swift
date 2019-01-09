import UIKit
import RealmSwift
class RoomListVC: UITableViewController{
    
    var rooms: Results<Room>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rooms = Room.all()
        tableView.rowHeight = 77
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(roomAdd))
    }
    
    @objc func roomAdd(){
        var allPreset = Preset.all()
        if allPreset.count >= 2{s
            
            var userList =   List<User>()
            var messageList = List<Message>()
            userList.append(User(preset: allPreset[0]))
            userList.append(User(preset: allPreset[1]))
            
            Room.add(users: userList, messages: messageList)
            tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoomCell.reuseId) as! RoomCell
        cell.room = rooms[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVc = ChatVC()
        chatVc.room = rooms[indexPath.row]
        
        self.navigationController?.pushViewController(chatVc, animated: true)
    }
    
    
}
