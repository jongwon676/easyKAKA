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
    
    func keyboardHide(){
        self.textView.resignFirstResponder()
        self.smileButton.resignFirstResponder()
    }
    var mode: ChatMode = .chatting{
        didSet{
            
            if mode == .chatting{
                [topView,middleView,bottomView].forEach{
                    $0.snp.updateConstraints({ (mk) in
                        mk.height.equalTo(elementHeight)
                    })
                }
                
            }else{
                [topView,bottomView].forEach{
                    $0.snp.updateConstraints({ (mk) in
                        mk.height.equalTo(0)
                    })
                }
                self.keyboardHide()
            }
            self.view.layoutIfNeeded()
        }
    }
    var users = List<User>()
    let layout = UICollectionViewFlowLayout()
    let realm = try! Realm()
    
    lazy var sendButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "ic_up"), for: .normal)
        btn.addTarget(self, action: #selector(sendMsg), for: .touchUpInside)
        return btn
    }()
    
    lazy var smileButton: TimeButton = {
        let btn = TimeButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "smileTemp.jpeg"), for: .normal)
        btn.delegate = self
        btn.addTarget(btn, action: #selector(becomeFirstResponder), for: .touchUpInside)
        btn.inputView = timeInputView
        return btn
    }()
    
    var hasText: Bool = false{ didSet{ } }
    
    
    
    weak var receiver: bottomInfoReceiver?
    

    lazy var userCollectionView:UICollectionView = {
       let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white
        return collection
    }()
    
    lazy var bannerView: GADBannerView = {
        let bv = GADBannerView()
        bv.rootViewController = self
        bv.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        bv.load(GADRequest())
        return bv
    }()
    
    
    lazy var textView: UITextView = {
        let textView = customTextView()
        textView.isUserInteractionEnabled = true
        textView.modeChecker = self
//        let textView = UITextView()
        textView.delegate = self
        textView.showsVerticalScrollIndicator = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = textViewInset
        textView.layer.cornerRadius = 16
        textView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        textView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.layer.borderWidth = 0.5
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = false
        return textView
    }()
    let textViewInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 30)

    let elementHeight: CGFloat = 50
    
    
    
    lazy var timeInputView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor.black
        tempView.frame.size.height = 300
        
        let btn0 = UIButton(type: .system)
        let btn1 = UIButton(type: .system)
        
        btn0.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        btn0.backgroundColor = UIColor.white
        btn1.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        btn1.backgroundColor = UIColor.white
        
        let btnStack = UIStackView(arrangedSubviews: [btn0,btn1])
        btnStack.spacing = 20
        btn0.setTitle("-", for: .normal)
        btn1.setTitle("+", for: .normal)
        btn0.addTarget(self, action: #selector(handleTime(_:)), for: .touchUpInside)
        btn1.addTarget(self, action: #selector(handleTime(_:)), for: .touchUpInside)
        btnStack.axis = .horizontal
        tempView.addSubview(btnStack)
        btnStack.snp.makeConstraints { (mk) in
            mk.center.equalTo(tempView)
        }
        return tempView
    }()
    
    lazy var topView: UIView = {
        userCollectionView.snp.makeConstraints { (mk) in
            mk.height.equalTo(elementHeight)
        }
        return userCollectionView
    }()
    
    lazy var middleView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white

        let specailFeatureButton = UIButton()
        specailFeatureButton.setImage(#imageLiteral(resourceName: "addImage"), for: .normal)
        
        let rightStackView = UIStackView()
        
        rightStackView.addArrangedSubview(smileButton)
        rightStackView.addArrangedSubview(sendButton)
        
        rightStackView.axis = .horizontal
        rightStackView.spacing = 15
        rightStackView.alignment = .center
        rightStackView.distribution = .fill
        
        smileButton.snp.makeConstraints { (mk) in
            mk.width.height.equalTo(20)
        }
        sendButton.snp.makeConstraints { (mk) in
            mk.width.height.equalTo(25)
        }
        containerView.addSubview(textView)
        containerView.addSubview(rightStackView)
        containerView.addSubview(specailFeatureButton)
        specailFeatureButton.snp.makeConstraints { (mk) in
            mk.left.equalTo(containerView).offset(10)
            mk.bottom.equalTo(containerView).inset(10)
            mk.width.height.equalTo(20)
        }
        textView.snp.makeConstraints({ (mk) in
            mk.top.equalTo(containerView.snp.top).offset(5)
            mk.bottom.equalTo(containerView.snp.bottom).offset(-5)
            mk.left.equalTo(specailFeatureButton.snp.right).offset(10)
            mk.right.equalTo(containerView).offset(-10)
            mk.height.equalTo(elementHeight - 10)
            
        })
        rightStackView.snp.makeConstraints { (mk) in
            mk.right.equalTo(textView.snp.right).inset(2)
            mk.width.equalTo(60)
            mk.height.equalTo(30)
            mk.bottom.equalTo(specailFeatureButton)
        }
        return containerView
    }()
    

    lazy var bottomView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.green
        containerView.snp.makeConstraints({ (mk) in
            mk.height.equalTo(elementHeight)
        })

        return containerView
    }()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userCollectionView.dataSource = self
        userCollectionView.delegate = self
        userCollectionView.register(UserCollectionCell.self, forCellWithReuseIdentifier:UserCollectionCell.reuseId)
        pickUser(idx: 0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(middleView)
        stackView.addArrangedSubview(bottomView)
        
    }
    
    @objc func sendMsg(){
        guard !textView.text.isEmpty else { return }
        receiver?.sendMessage(text: textView.text)
        textView.text = ""
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
        return stackView
    }()
    override func loadView() {
        self.view = stackView
    }
    
    
    
}









extension KeyBoardAreaController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = userCollectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionCell.reuseId, for: indexPath) as! UserCollectionCell
        cell.user = users[indexPath.item]
        cell.backgroundColor = UIColor.clear
        return cell
        
    }
}







extension KeyBoardAreaController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size:CGFloat = collectionView.frame.size.height
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pickUser(idx: indexPath.item)
    }
    
    func resetSelectedUser(){
        for idx in 0 ..< users.count{
            try! realm.write{
                users[idx].isSelected = false
            }
        }
    }
    
    func pickUser(idx: Int){
        guard users.count > 0 else { return }
        
        resetSelectedUser()
        try! realm.write {
            users[idx].isSelected = true
        }
        userCollectionView.reloadData()
    }
    
    var selectedUser: User?{
        get{
            for idx in 0 ..< users.count{
                if users[idx].isSelected {
                    return users[idx]
                }
            }
            if users.count > 0 {
                users[0].isSelected = true
                return users[0]
            }
            return nil
        }
    }
}

let maxHeight: CGFloat = 80

extension KeyBoardAreaController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        self.hasText = !textView.text.isEmpty
        
        var nextHeight = min(estimateSize.height + textViewInset.top + textViewInset.bottom, maxHeight)
        nextHeight = max(elementHeight - 10 , nextHeight)
        textView.isScrollEnabled = (nextHeight >= maxHeight)
        textView.snp.updateConstraints { (mk) in
            mk.height.equalTo(nextHeight)
        }
    }
}




class customTextView: UITextView{
    var modeChecker: KeyBoardAreaController?
    override func becomeFirstResponder() -> Bool {
        modeChecker?.mode = .chatting
        return super.becomeFirstResponder()
    }
}














extension KeyBoardAreaController: FirstResponderControlDelegate{
    func firstResponderControl(_ control: TimeButton, didReceiveText text: String) {
        
    }
    
    func firstResponderControlDidDeleteBackwards(_ control: TimeButton) {
        
    }
    
    func firstResponderControlHasText(_ control: TimeButton) -> Bool {
        return true
    }
    
    
}







protocol FirstResponderControlDelegate: class {
    func firstResponderControl(_ control: TimeButton, didReceiveText text: String)
    func firstResponderControlDidDeleteBackwards(_ control: TimeButton)
    func firstResponderControlHasText(_ control: TimeButton) -> Bool
}





class TimeButton: UIButton, UIKeyInput {
    var hasText: Bool{
        return true
//        return self.delegate?.firstResponderControlHasText(self) ?? false
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    private var _inputView: UIView?
    override var inputView: UIView? {
        get {
            return _inputView
        }
        set {
            _inputView = newValue
        }
    }
    
    weak var delegate: FirstResponderControlDelegate?

    
    func insertText(_ text: String) {
        self.delegate?.firstResponderControl(self, didReceiveText: text)
    }
    
    func deleteBackward() {
        self.delegate?.firstResponderControlDidDeleteBackwards(self)
    }
    
}



