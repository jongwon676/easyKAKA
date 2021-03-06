import UIKit
class AddUserVC: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        
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

        if user != nil{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        profile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapProfile(_:))))

    }
    
    
    @objc func save(){

        guard let name = nameField.text, let image = profile.image else { return }
        if user != nil{
            user?.edit(name: name, image: image)
            self.navigationController?.popViewController(animated: true)
        }else{
            Preset.add(name: name, image: image)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func tapProfile(_ sender: UIImageView){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.profile.image = img
        }
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func editChanged(_ sender: UITextField) {
        if (sender.text?.isEmpty)!{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }else{
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}


