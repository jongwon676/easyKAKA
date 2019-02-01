import UIKit
class AddUserController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    @IBOutlet var addUserButton: UIButton!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserButton.imageView?.contentMode = .scaleAspectFit
        addUserButton.imageView?.layer.masksToBounds = true
        
    }
    
}
