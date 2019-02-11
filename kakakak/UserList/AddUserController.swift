import UIKit
class AddUserController: UIViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate{
    
    
    var topCnt: Int = 0
    var bottomCnt: Int = 30
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    var profileImage: UIImage?{
        didSet{
            if profileImage == nil{
                profile.maskToBounds = false
                profile.image = #imageLiteral(resourceName: "uploadDefault")
            }else{
                profile.maskToBounds = true
                profile.image = profileImage
            }
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profile.layer.cornerRadius = profile.frame.size.width / 2
        if profileImage == nil{
            profile.layer.masksToBounds = false
        }else{
            profile.layer.masksToBounds = true
        }
        
    }
    
    @IBOutlet var limtLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var profile: UIImageView!
    @IBOutlet var nameField: UITextField!{
        didSet{
            nameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            
        }
    }
    var user: Preset? = nil
    
    @objc func saveKeyboardHeight(_ notification: NSNotification){
        guard let userInfo = notification.userInfo else { return }
        
        let keyFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if keyFrame.height > 180{
            let plist = UserDefaults.standard
            plist.set(keyFrame.height, forKey: "keyboardHeight")
            plist.synchronize()
        }
        
        let show = (notification.name == UIResponder.keyboardWillShowNotification)
            ? true
            : false
        
        
//        let adjustmentHeight = keyboardFrame.height  * (show ? 1 : -1)
        
        if show {
        
        scrollView.contentInset.bottom = keyFrame.height
        scrollView.scrollIndicatorInsets.bottom = keyFrame.height
            
        }else{
            scrollView.contentInset.bottom = 0
            scrollView.scrollIndicatorInsets.bottom = 0
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func changeImage(_ sender: Any) {
        let picker = UIImagePickerController()
        
        self.addAction(titleString: "", messageString: "사진을 가져올 곳을 선택해주세요.")
        
//        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
//        self.present(picker, animated: true, completion: nil)
    }
    
    func addAction(titleString: String?, messageString: String?){
        
        let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (_) in
                ImagePickerHelper.imagePicker(.camera, vc: self)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default, handler: { (_) in
                ImagePickerHelper.imagePicker(.savedPhotosAlbum, vc: self)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default, handler: { (_) in
                ImagePickerHelper.imagePicker(.photoLibrary, vc: self)
            }))
        }
        if profileImage != nil{
            alert.addAction(UIAlertAction(title: "기본 사진으로 되돌리기", style: .default, handler: { (_) in
                self.profileImage = nil
            }))
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alert, animated: true)
        
    }
    
    
    
    @IBOutlet var addUserButton: UIButton!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    @objc func handleEditEnd(){
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserButton.imageView?.contentMode = .scaleAspectFit
        addUserButton.imageView?.layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleEditEnd))
        self.view.addGestureRecognizer(gesture)
        
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveKeyboardHeight),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
       
    
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveKeyboardHeight),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        
        nameField.delegate = self
        nameField.text = user?.name
        if let imgName = user?.profileImageUrl,let image = UIImage.loadImageFromName(imgName){
            profileImage = image
        }
        
        
        if user != nil{
            
            limtLabel.text = String(user!.name.count) + "/" + String(bottomCnt)
        }else{
            limtLabel.text = String(0) + "/" + String(bottomCnt)
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
            profileImage = img

        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        guard let topCount = textField.text?.count else {
            return
        }
        
        limtLabel.text = String(topCount) + "/" + String(bottomCnt)
        if topCount > bottomCnt{
            limtLabel.textColor = UIColor.red
        }else{
            limtLabel.textColor = #colorLiteral(red: 0.740267694, green: 0.768337667, blue: 0.7933139205, alpha: 1)
        }
        
    }
}
