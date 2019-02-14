import UIKit
import RealmSwift
import GoogleMobileAds
class RoomListVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet var tableView: UITableView!
    var token: NotificationToken?
    var rooms: Results<Room>!
    var bannerView: GADBannerView = GADBannerView(frame:  CGRect(x: 0, y: 0, width: 200, height: 200))
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        rooms = Room.all()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
    }
//    
//    @objc func roomAdd(){
//        let allPreset = Preset.all()
//        if allPreset.count >= 2{
//            let userList =   List<User>()
//            userList.append(objectsIn: [User(preset: allPreset[0]),User(preset: allPreset[1])])
//            let messages = List<Message>()
//            Room.add(users: userList, messages: messages)
//            
//            tableView.reloadData()
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        addButton.isHidden = true
        token?.invalidate()
        shadowImageView?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addButton.isHidden = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.tabBarController?.tabBar.isHidden = false
        
        token = rooms.observe{
            [weak tableView] changes in
            guard let tableView = tableView else { return }
            switch changes{
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                if deletions.count > 0 {
                    let paths = deletions.map{IndexPath.row(row: $0)}
                    tableView.deleteRows(at: paths, with: .fade)
                }else{
                    tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
                }
            case .error: break
            }
        }
        
        tableView.reloadData()
        (self.navigationController as? ColorNavigationViewController)?.setRoomListNav()
        if shadowImageView == nil {
                shadowImageView = findShadowImage(under: navigationController!.navigationBar)
        }
        shadowImageView?.isHidden = true
        
        

        
    }
    private var shadowImageView: UIImageView?
    private func findShadowImage(under view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1 {
            return (view as! UIImageView)
        }
        
        for subview in view.subviews {
            if let imageView = findShadowImage(under: subview) {
                return imageView
            }
        }
        return nil
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
            chatvc.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.pushViewController(chatvc, animated: true)
        }
    }
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let alert = UIAlertController(title: "삭제된 데이터는 복구 할 수 없습니다.", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (action) in
            self.rooms[indexPath.row].remove()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
            
            self.present(alert, animated: true, completion: nil)
            
                        
            completionHandler(true)
        }
        

        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        deleteAction.image = UIImage(named: "bomb")
        
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
    }
    
    
    
    
    /// WARNING: Change these constants according to your project's design
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 20
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 20
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    var addButton = UIButton(type: .custom)
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(named: "addBtn"), for: .normal)
        addButton.addTarget(self, action: #selector(addBtnClicked(_:)), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            addButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            addButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            addButton.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor)
            ])
    }
    
    
    @objc func addBtnClicked(_ sender: UIButton){
        if let roomAddVC = storyboard?.instantiateViewController(withIdentifier: "RoomAddVC") as? RoomAddVC{
            roomAddVC.type = .create
            self.present(roomAddVC, animated: true, completion: nil)

        }
    }
    
}
