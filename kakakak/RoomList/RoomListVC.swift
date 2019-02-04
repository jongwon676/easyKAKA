import UIKit
import RealmSwift
import GoogleMobileAds
class RoomListVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet var tableView: UITableView!
    
    var rooms: Results<Room>!
    var bannerView: GADBannerView = GADBannerView(frame:  CGRect(x: 0, y: 0, width: 200, height: 200))
    override func viewDidLoad() {
        super.viewDidLoad()
        rooms = Room.all()
//        tableView.delegate = self
//        tableView.rowHeight = 77
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        
        
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
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RoomCell.reuseId) as! RoomCell
        cell.room = rooms[indexPath.row]
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "MessageEdit", bundle: Bundle.main)
        
        if let chatvc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC{
           chatvc.room = rooms[indexPath.row]
            self.navigationController?.pushViewController(chatvc, animated: true)
        }
    }
}
