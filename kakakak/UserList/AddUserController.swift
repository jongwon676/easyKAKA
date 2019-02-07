import UIKit
class AddUserController: UIViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    @IBOutlet var profile: UIImageView!
    @IBOutlet var nameField: UITextField!
    var user: Preset? = nil
    
    @objc func saveKeyboardHeight(_ notification: NSNotification){
        guard let userInfo = notification.userInfo else { return }
        
        let keyFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if keyFrame.height > 180{
            let plist = UserDefaults.standard
            plist.set(keyFrame.height, forKey: "keyboardHeight")
            plist.synchronize()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func changeImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBOutlet var addUserButton: UIButton!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserButton.imageView?.contentMode = .scaleAspectFit
        addUserButton.imageView?.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveKeyboardHeight),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        
        nameField.delegate = self
        nameField.text = user?.name
        if let imgName = user?.profileImageUrl,let image = UIImage.loadImageFromName(imgName){
            profile.image = image
        }
        
        
    }
    @IBAction func save(){
        
        guard let name = nameField.text, let image = profile.image else { return }
        if user != nil{
            user?.edit(name: name, image: image)
            self.navigationController?.popViewController(animated: true)
        }else{
            Preset.add(name: name, image: image)
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.profile.image = img
        }
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func editChanged(_ sender: UITextField) {
        if (sender.text?.isEmpty)!{
            
        }else{
            
        }
    }
    
}
