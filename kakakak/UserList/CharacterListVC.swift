import Foundation
import UIKit
import RealmSwift
class CharacterListVC: UITableViewController{
    
    

    var presets: Results<Preset>!
    var token: NotificationToken?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupUI()
        presets = Preset.getListAlivePreset()
        tableView.bounces = true
    }
    
    
    func setNavTitle(){
        self.navigationItem.title = "친구 " + String(presets.count) + "명"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        setNavTitle()
        token = presets?.observe{
            [weak tableView] changes in
            guard let tableView = tableView else { return }
            switch changes{
            case .initial:
                tableView.reloadData()
                self.setNavTitle()
            case .update(_, let deletions, let insertions, let updates): tableView.reloadData()
                self.setNavTitle()
            case .error: break
            }
        }
        addButton.isHidden = false
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        token?.invalidate()
        addButton.isHidden = true
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
    
    
    @objc func addBtnClicked(_ sender: UIButton){
        if let editUserVc = storyboard?.instantiateViewController(withIdentifier: "AddUserController") as? AddUserController{
            
            self.navigationController?.pushViewController(editUserVc, animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let editUserVc = storyboard?.instantiateViewController(withIdentifier: "AddUserController") as? AddUserController{
            editUserVc.user = presets[indexPath.row]
            self.navigationController?.pushViewController(editUserVc, animated: true)
        }
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let alert = UIAlertController(title: "삭제된 데이터는 복구 할 수 없습니다.", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (action) in
            self.presets[indexPath.row].delete()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, sourceView, completionHandler) in
            
            self.present(alert, animated: true, completion: nil)
            
            
            completionHandler(true)
        }
        
        
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        deleteAction.title = "삭제"
//        deleteAction.image = UIImage(named: "bomb")
        
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
    }
    
    
    
    
}



