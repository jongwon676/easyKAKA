import UIKit
import RealmSwift
import GoogleMobileAds
class RoomListVC: UITableViewController{
    
    var rooms: Results<Room>!
    var bannerView: GADBannerView = GADBannerView(frame:  CGRect(x: 0, y: 0, width: 200, height: 200))
    override func viewDidLoad() {
        super.viewDidLoad()
        rooms = Room.all()
        tableView.rowHeight = 77
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(roomAdd))
        
        
        
    }
    
    @objc func roomAdd(){
        let allPreset = Preset.all()
        if allPreset.count >= 2{
            let userList =   List<User>()
            userList.append(objectsIn: [User(preset: allPreset[0]),User(preset: allPreset[1])])
            let messages = List<Message>()
            Room.add(users: userList, messages: messages)
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
