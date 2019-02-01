import Foundation
import UIKit
import RealmSwift
class CharacterListVC: UITableViewController{
    
    

    var presets: Results<Preset>!
    var token: NotificationToken?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 70
        
        presets = Preset.all()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "친구 " + String(presets.count) + "명"
        token = presets?.observe{
            [weak tableView] changes in
            guard let tableView = tableView else { return }
            switch changes{
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates): tableView.reloadData()
            case .error: break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        token?.invalidate()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell") as! CharacterCell
        
        cell.profileImage.image = UIImage.loadImageFromName(presets[indexPath.row].profileImageUrl)
        cell.nameLabel.text = presets[indexPath.row].name
        
        return cell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let editUserVc = storyboard?.instantiateViewController(withIdentifier: "UserEditVC") as? AddUserVC{
            editUserVc.user = presets[indexPath.row]
            self.navigationController?.pushViewController(editUserVc, animated: true)
        }
    }
}
