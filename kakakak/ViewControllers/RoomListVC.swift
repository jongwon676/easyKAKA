import UIKit
import RealmSwift
class RoomListVC: UITableViewController{
    
    var rooms: Results<Room>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rooms = Room.all()
        tableView.rowHeight = 77
        
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
