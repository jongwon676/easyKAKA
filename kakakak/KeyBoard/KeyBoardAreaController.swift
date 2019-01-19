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
    
    func keyboardHide(){
        self.middleView.textView.resignFirstResponder()
        self.middleView.smileButton.resignFirstResponder()
    }
    
    var mode: ChatMode = .chatting{
        didSet{
            
            if mode == .chatting{
                [topView,bottomView].forEach{
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
    
    var users = List<User>() {
        didSet{
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
    
    let elementHeight: CGFloat = 50
    
    
    
    lazy var timeInputView: TimeInputView = {
        let tempView = TimeInputView()
        tempView.frame.size.height = 300
        tempView.decButton.addTarget(self, action: #selector(handleTime(_:)), for: .touchUpInside)
        tempView.incButton.addTarget(self, action: #selector(handleTime(_:)), for: .touchUpInside)
        return tempView
    }()
    
    lazy var topView: UIView = {
        userCollectionView.snp.makeConstraints { (mk) in
            mk.height.equalTo(elementHeight)
        }
        userCollectionView.backgroundColor = UIColor.white
        return userCollectionView
    }()
    
    
    lazy var middleView: MiddleView = {
       let view = MiddleView()
        view.sendButton.addTarget(self, action: #selector(sendMsg), for: .touchUpInside)
        view.smileButton.addTarget(self, action: #selector(becomeFirstResponder), for: .touchUpInside)
        return view
    }()
    

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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        userCollectionView.dataSource = self
        userCollectionView.delegate = self
        userCollectionView.register(UserCollectionCell.self, forCellWithReuseIdentifier:UserCollectionCell.reuseId)
        
        middleView.smileButton.delegate = self
        middleView.smileButton.inputView = timeInputView
        middleView.textView.modeChecker = self
        middleView.textView.delegate = self
        
        
        pickUser(idx: 0)
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(middleView)
        stackView.addArrangedSubview(bottomView)
 
    }
    deinit {
        print("keyboardarea deinit")
    }

    @objc func sendMsg(){
        guard !self.middleView.isEmpty() else { return }
        receiver?.sendMessage(text: middleView.text)
        middleView.text = ""
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
            var ret: User? = nil
            for idx in 0 ..< users.count{
                if users[idx].isSelected {
                    ret = users[idx]
                    break
                }
            }
            try! realm.write {
                if users.count > 0 {
                    users[0].isSelected = true
                    ret = users[0]
                }
            }
            return ret
        }
        
    }
}


let maxHeight: CGFloat = 120

extension KeyBoardAreaController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        self.hasText = !textView.text.isEmpty
        print(textView.frame.height)
//        print(estimateSize.height + textViewInset.top + textViewInset.bottom)
        var nextHeight = min(estimateSize.height, maxHeight)
        nextHeight = max(elementHeight - 20 , nextHeight)
        textView.isScrollEnabled = (nextHeight >= maxHeight)
        textView.snp.updateConstraints { (mk) in
            mk.height.equalTo(nextHeight)
        }
        
        
    }
}




class customTextView: UITextView{
    weak var modeChecker: KeyBoardAreaController?
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



