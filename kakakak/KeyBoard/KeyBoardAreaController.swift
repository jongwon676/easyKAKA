import Foundation
import UIKit
import RealmSwift
import GoogleMobileAds
import SnapKit

enum chatState{
    case capture
    case chatting
}

protocol bottomInfoReceiver: class {
    func addMinute(minute: Int)
    func sendMessage(text: String)
}

enum ChatMode{
    case capture
    case chatting
}

class KeyBoardAreaController: UIViewController{
    
    var keyFrame: CGRect? = nil
    weak var messageManager: MessageProcessor?
    
    func keyboardHide(){
//        self.middleView.textView.resignFirstResponder()
//        self.middleView.smileButton.resignFirstResponder()
//        self.middleView.specailFeatureButton.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    
    
    var mode: ChatMode = .chatting{
        didSet{
//            
//            if mode == .chatting{
//                [topView,bottomView].forEach{
//                    $0.snp.updateConstraints({ (mk) in
//                        mk.height.equalTo(elementHeight)
//                    })
//                }
//                
//            }else{
//                [topView,bottomView].forEach{
//                    $0.snp.updateConstraints({ (mk) in
//                        mk.height.equalTo(0)
//                    })
//                }
//                self.keyboardHide()
//            }
//            self.view.layoutIfNeeded()
        }
    }
    
    var users = List<User>() {
        didSet{
            print("set user")
            userCollectionView.reloadData()
        }
    }
    
    let layout = UICollectionViewFlowLayout()
    let realm = try! Realm()
    
    var hasText: Bool = false{
        didSet{
            middleView.sendButton.setImage(UIImage(named: hasText ? "enter" : "sharp"), for: .normal)
        }
    }
    
    
    
    weak var receiver: bottomInfoReceiver?
    
    lazy var userCollectionView: UserCollectionView = {
        let collection = UserCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return collection
    }()
    
    lazy var bannerView: GADBannerView = {
        let bv = GADBannerView()
        bv.rootViewController = self
        bv.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        bv.load(GADRequest())
        return bv
    }()
    
    let elementHeight: CGFloat = 50
    
    
    
    lazy var timeInputView: TimeInputView = {
        let tempView = TimeInputView()
        
        
        let plist = UserDefaults.standard
        let keyboardHeight = plist.double(forKey: "keyboardHeight")
        if keyboardHeight >= 180{
            tempView.frame.size.height = CGFloat(keyboardHeight)
        }else{
            tempView.autoresizingMask = .flexibleHeight
        }
        return tempView
    }()
    
    lazy var topView: UIView = {
        userCollectionView.snp.makeConstraints { (mk) in
            mk.height.equalTo(90)
        }
        userCollectionView.showsHorizontalScrollIndicator = false 
        userCollectionView.backgroundColor = #colorLiteral(red: 0.7427546382, green: 0.8191892505, blue: 0.8610599637, alpha: 1)
        return userCollectionView
    }()
    
    
    lazy var middleView: MiddleView = {
        let view = MiddleView()
        view.sendButton.addTarget(self, action: #selector(sendMsg), for: .touchUpInside)
        //        view.smileButton.addTarget(self, action: #selector(becomeFirstResponder), for: .touchUpInside)
        view.smileButton.addTarget(self, action: #selector(checker), for: .touchUpInside)
        return view
    }()
    @objc func checker(){
        middleView.smileButton.becomeFirstResponder()
        print(middleView.smileButton.isFirstResponder)
    }
    
    lazy var bottomView: UIView = {
        
        var bannerView = GADBannerView()
        bannerView.backgroundColor = UIColor.white
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.snp.makeConstraints({ (mk) in
            mk.height.equalTo(elementHeight)
        })
        
        return bannerView
    }()
    lazy var spView: SpeacialFeatureInputView = {
        let view = SpeacialFeatureInputView(frame: .zero)
        let plist = UserDefaults.standard
        let keyboardHeight = plist.double(forKey: "keyboardHeight")
        if keyboardHeight >= 180{
            view.frame.size.height = CGFloat(keyboardHeight)
        }else{
            view.autoresizingMask = .flexibleHeight
        }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UserLayout()
        
        middleView.specailFeatureButton.inputView = spView
        spView.collectionView.delegate = self
        userCollectionView.collectionViewLayout = layout
        userCollectionView.dataSource = self
        userCollectionView.delegate = self
        userCollectionView.register(UserCollectionCell.self, forCellWithReuseIdentifier:UserCollectionCell.reuseId)
        
        
        
        middleView.smileButton.delegate = self
        middleView.smileButton.inputView = timeInputView
        middleView.textView.modeChecker = self
        middleView.textView.delegate = self
        
        
        //        pickUser(idx: 0)
        
        
        layout.scrollDirection = .horizontal
        
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(middleView)
        stackView.addArrangedSubview(bottomView)
        
    }
    //
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /*
         let middleIndexPath = IndexPath(item: users.count / 2, section: 0)
         selectCell(for: middleIndexPath, animated: false)
         */
        //
        
    }
    deinit {
        print("keyboardarea deinit")
    }
    
    @objc func sendMsg(){
        guard !self.middleView.isEmpty() else { return }
        receiver?.sendMessage(text: middleView.text)
        middleView.text = ""
        textViewDidChange(middleView.textView)

        print(stackView.frame.height)
        //        textViewDidChange(_ middleView.textView: UITextView)
    }
    
    
    @objc func handleTime(_ sender: UIButton){
        if sender.titleLabel?.text == "+"{
            receiver?.addMinute(minute: 1)
        }else{
            receiver?.addMinute(minute: -1)
        }
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    
    
    override func loadView() {
        self.view = stackView
    }
}


extension KeyBoardAreaController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        #colorLiteral(red: 0.004580542445, green: 0.01560623012, blue: 0.2958489656, alpha: 1)
        return users.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userCollectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionCell.reuseId, for: indexPath) as! UserCollectionCell
        //        cell.setRadius()
        cell.user = users[indexPath.item]
        cell.backgroundColor = UIColor.clear
        return cell
    }
}



extension KeyBoardAreaController: UICollectionViewDelegateFlowLayout{
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (collectionView as? UserCollectionView) != nil{ //유저 클릭
            selectCell(for: indexPath, animated: true)
        }else{ // 특수기능 버튼 클릭
            
            switch indexPath.row{
            case 0: messageImageAlert()
            case 1: dateAlert()
                
            case 2: voiceTalkAlert()
            case 3: recordAlert()
            case 4:
                guard let user = selectedUser else { return }
                messageManager?.sendDeleteMessage(owner: user)
//                messageManager.sendDeleteMessage(sele)
            case 5: faceTalkAlert()
            default: ()
            }
        }
    }
    
    func resetSelectedUser(){
        for idx in 0 ..< users.count{
            try! realm.write{
                users[idx].isSelected = false
            }
        }
    }
    
    
    
    var selectedUser: User?{
        guard let indexPath = centeredIndex() else { return nil }
        return users[indexPath.item]
    }
    
    func getKeyBoardHeight() -> CGFloat {
        return stackView.frame.height
    }
}


let maxHeight: CGFloat = 90
let minHeight: CGFloat = 36
extension KeyBoardAreaController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        self.hasText = !textView.text.isEmpty
        var nextHeight = min(estimateSize.height, maxHeight)
        nextHeight = max(elementHeight - 20 , nextHeight)
        nextHeight = max(minHeight,nextHeight)
        
        textView.isScrollEnabled = (nextHeight >= maxHeight)
        textView.snp.updateConstraints { (mk) in
            mk.height.equalTo(nextHeight)
        }
    }
}

extension KeyBoardAreaController: UIScrollViewDelegate{
    
    func centeredIndex() -> IndexPath?{
        let bounds = userCollectionView.bounds
        let xPosition = userCollectionView.contentOffset.x + bounds.size.width / 2.0
        var scrollItem = -1
        
        var dist: CGFloat = 5000
        for idx in (0 ..< userCollectionView.numberOfItems(inSection: 0)){
            if let cent = self.userCollectionView.layoutAttributesForItem(at: IndexPath(item: idx, section: 0))?.center{
                
                if abs(cent.x - xPosition) < dist{
                    dist = abs(cent.x - xPosition)
                    scrollItem = idx
                }
            }
        }
        
        if scrollItem == -1 { return nil }
        return IndexPath(item: scrollItem, section: 0)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = centeredIndex() else { return  }
        selectCell(for: indexPath, animated: true)
    }
    
    private func selectCell(for indexPath: IndexPath, animated: Bool) {
        userCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        
        messageManager?.userReadMessage(owner: users[indexPath.row])
        
        
//        messageManager
        
    }
    
    //    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    //        scrollViewDidEndDecelerating(scrollView)
    //    }
    //
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        if !decelerate {
    //            scrollViewDidEndDecelerating(scrollView)
    //        }
    //    }
    
}



class customTextView: UITextView{
    weak var modeChecker: KeyBoardAreaController?
    override func becomeFirstResponder() -> Bool {
        modeChecker?.mode = .chatting
        return super.becomeFirstResponder()
    }
}














extension KeyBoardAreaController: FirstResponderControlDelegate{
    func firstResponderControl(_ control: CustomFocusControl, didReceiveText text: String) {
        
    }
    
    func firstResponderControlDidDeleteBackwards(_ control: CustomFocusControl) {
        
    }
    
    func firstResponderControlHasText(_ control: CustomFocusControl) -> Bool {
        return true
    }
    
}





extension KeyBoardAreaController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func messageImageAlert(){
        let alert = UIAlertController(title: nil, message: "사진을 가져올 곳을 선택해주세요.", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (_) in
                self.imagePicker(.camera)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default, handler: { (_) in
                self.imagePicker(.savedPhotosAlbum)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default, handler: { (_) in
                self.imagePicker(.photoLibrary)
            }))
        }
        self.view.endEditing(true)
        self.present(alert, animated: true)
    }
    func imagePicker(_ source: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
//        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            guard let user = selectedUser else { return }
            let imgName = Date().currentDateToString() + ".jpg"
            if img.writeImage(imgName: imgName){
                messageManager?.sendMessaegImage(imageName: imgName, user: user)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func dateAlert() {
        let alert = UIAlertController(style: .actionSheet, title: nil, message: "날짜선 추가")
        var newDate = Date()
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: nil, maximumDate: nil) { date in
            Log(date)
            newDate = date
        }
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in
            self.messageManager?.addDateLine(sendDate: newDate)
        }))
        alert.addAction(title: "취소", style: .cancel)
        alert.show()
    }
    fileprivate func recordAlert(){
        
        
        durationAlert(type: .record, ctype: nil)
    }
    
    fileprivate func durationAlert(type: Message.MessageType, ctype: Message.callType?){
        
        guard let owner = self.selectedUser else { return  }
        
        var title = ""
        if type == .record {
            title = "녹음시간을 선택해주세요."
        }else {
            title = "통화시간을 선택해주세요."
        }
        let alert = UIAlertController(style: .alert, title: title, message: nil)
        
        let frameSizes: [CGFloat] = (0...59).map { CGFloat($0) }
        let pickerViewValues: [[String]] = [frameSizes.map { Int($0).description + "분" },frameSizes.map { Int($0).description + "초"}]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        
        var row1: Int = 0
        var row2: Int = 0
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            
            row1 = picker.selectedRow(inComponent: 0)
            row2 = picker.selectedRow(inComponent: 1)
            
        }
        
        alert.addAction(title: "취소", style: .cancel)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
            if type == .record{
                self.messageManager?.sendRecordMessage(owner: owner, minute: row1, second: row2)
            }else{
                guard let callType = ctype else { return }
                self.messageManager?.sendCallMessage(owner: owner, minute: row1, second: row2, callType: callType)
            }
        }))
        alert.show()
        
    }
    
    
    
    fileprivate func voiceTalkAlert(){
        guard let owner = selectedUser else {
            return
        }
        let alert = UIAlertController(title: "보이스톡 종류 선택", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "보이스톡 해요", style: .default, handler: { (action) in
            self.messageManager?.sendCallMessage(owner: owner, minute: 0, second: 0, callType: .voiceTry)
        }))
        
        alert.addAction(UIAlertAction(title: "보이스톡 취소", style: .default, handler: { (action) in
            self.messageManager?.sendCallMessage(owner: owner, minute: 0, second: 0, callType: .voiceCancel)
        }))
        
        alert.addAction(UIAlertAction(title: "보이스톡 부재중", style: .default, handler: { (action) in
            self.messageManager?.sendCallMessage(owner: owner, minute: 0, second: 0, callType: .voiceAbsent)
        }))
        
        alert.addAction(UIAlertAction(title: "보이스톡 통화", style: .default, handler: { (action) in
            self.durationAlert(type: .call, ctype: .voiceSuccess)
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.show()
    }
    fileprivate func faceTalkAlert(){
        guard let owner = selectedUser else {
            return
        }
        let alert = UIAlertController(title: "페이스톡 종류 선택", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "페이스톡 해요", style: .default, handler: { (action) in
            self.messageManager?.sendCallMessage(owner: owner, minute: 0, second: 0, callType: .faceTry)
        }))
        
        alert.addAction(UIAlertAction(title: "페이스톡 취소", style: .default, handler: { (action) in
            self.messageManager?.sendCallMessage(owner: owner, minute: 0, second: 0, callType: .faceCancel)
        }))
        
        alert.addAction(UIAlertAction(title: "페이스톡 부재중", style: .default, handler: { (action) in
            self.messageManager?.sendCallMessage(owner: owner, minute: 0, second: 0, callType: .faceAbsent)
        }))
        
        alert.addAction(UIAlertAction(title: "페이스톡 통화", style: .default, handler: { (action) in
            self.durationAlert(type: .call, ctype: .faceSuccess)
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.show()
    }
}





