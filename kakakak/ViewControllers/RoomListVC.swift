import UIKit
import RealmSwift
class RoomListVC: UITableViewController{
    
    var rooms: Results<Room>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rooms = Room.all()
        tableView.rowHeight = 77
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
    
}
