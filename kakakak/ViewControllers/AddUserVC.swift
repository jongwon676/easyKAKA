import UIKit
class AddUserVC: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet var profile: UIImageView!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var stateField: UITextField!
    @IBOutlet var isMe: UISwitch!
    
    override func viewDidLoad() {
        profile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapProfile(_:))))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
    }
    
    
    @objc func save(){
        let imageName = Date().currentDateToString() + ".jpg"
        profile.image?.writeImage(imgName: imageName)
        Preset.add(name: nameField.text!, profileImageUrl: imageName)
        self.navigationController?.popViewController(animated: true)
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
    
}

