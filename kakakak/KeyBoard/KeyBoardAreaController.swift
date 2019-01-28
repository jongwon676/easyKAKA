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
        self.middleView.specailFeatureButton.resignFirstResponder()
    }
    
    var mode: ChatMode = .chatting{
        didSet{
            
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
            self.view.layoutIfNeeded()
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
//        tempView.frame.size.height = 300
//        tempView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        
        tempView.decButton.addTarget(self, action: #selector(handleTime(_:)), for: .touchUpInside)
        tempView.incButton.addTarget(self, action: #selector(handleTime(_:)), for: .touchUpInside)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UserLayout()
        
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let middleIndexPath = IndexPath(item: users.count / 2, section: 0)
        selectCell(for: middleIndexPath, animated: false)
//        userCollectionView.setNeedsDisplay()
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
//        cell.setRadius()
        cell.user = users[indexPath.item]
        cell.backgroundColor = UIColor.clear
        return cell
    }
}



extension KeyBoardAreaController: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCell(for: indexPath, animated: true)
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
}


let maxHeight: CGFloat = 120

extension KeyBoardAreaController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        self.hasText = !textView.text.isEmpty
        var nextHeight = min(estimateSize.height, maxHeight)
        nextHeight = max(elementHeight - 20 , nextHeight)
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
        
        var dist:CGFloat = 5000
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






