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
    
}

class KeyBoardAreaController: UIViewController{
    var users = List<User>()
    let layout = UICollectionViewFlowLayout()
    
    
    lazy var sendButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "ic_up"), for: .normal)
        return btn
    }()
    
    
    lazy var smileButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(#imageLiteral(resourceName: "smileTemp.jpeg"), for: .normal)
        return btn
    }()
    
    
    var hasText: Bool = false{
        didSet{
            
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
    
    
    public var textView = UITextView()
    public var textField = UITextField()
    
    let elementHeight: CGFloat = 50
    
    let textViewInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 30)
    
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
        
        textField.inputView = tempView
        return tempView
    }()
    
    
    func setupTop(){
//        let containerView = UIView()
//        containerView.backgroundColor = UIColor.red
//        containerView.snp.makeConstraints({ (mk) in
//            mk.height.equalTo(elementHeight)
//        })
//        containerView.addSubview(textField)
        stackView.addArrangedSubview(userCollectionView)
        
//        textField.snp.makeConstraints { (mk) in
//            mk.left.right.bottom.top.equalTo(containerView)
//        }
        userCollectionView.snp.makeConstraints { (mk) in
            mk.height.equalTo(elementHeight)
        }

    }
    
    func setupMiddle(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        
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
        stackView.addArrangedSubview(containerView)
    }
    func setupBottom(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.green
        containerView.snp.makeConstraints({ (mk) in
            mk.height.equalTo(elementHeight)
        })
        stackView.addArrangedSubview(containerView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCollectionView.dataSource = self
        userCollectionView.delegate = self
        userCollectionView.register(UserCollectionCell.self, forCellWithReuseIdentifier:UserCollectionCell.reuseId)
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
    
        setupTop()
        setupMiddle()
        setupBottom()
        
    }
    
    @objc func handleTime(_ sender: UIButton){
        if sender.titleLabel?.text == "+"{
            receiver?.addMinute(minute: 1)
        }else{
            receiver?.addMinute(minute: -1)
        }
    }
    class RespondingButton: UIButton, UIKeyInput {
        override var canBecomeFirstResponder: Bool {
            return true
        }
        var hasText: Bool = true
        func insertText(_ text: String) {}
        func deleteBackward() {}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        let cell = userCollectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionCell.reuseId, for: indexPath)
        cell.backgroundColor = UIColor.magenta
        return cell
    
    }
}

extension KeyBoardAreaController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size:CGFloat = collectionView.frame.size.height
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
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

