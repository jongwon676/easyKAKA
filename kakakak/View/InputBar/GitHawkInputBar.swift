import UIKit
import InputBarAccessoryView
import GoogleMobileAds
class GitHawkInputBar: InputBarAccessoryView,UICollectionViewDelegate{
    
    var isFirstLoad: Bool = true
    var selectedUser:User?{
        get{
            for user in users{
                if user.isSelected { return user }
            }
            return nil
        }
    }
    func addUser(user: User){
        user.isSelected = false
        users.append(user)
    }
    func clearUser(){
        users.removeAll()
    }
    func resetUserSelected(){
        for user in users{
            user.isSelected = false
        }
    }
    
    private var users: [User] = []
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        setupTextView()
        setupLeft()
        setupRight()
        setupTop()
        setupBottom()
//        inputViewController
    }
   
    
    
    func setupTextView(){
        inputTextView.placeholder = "Leave a comment"
        inputTextView.keyboardType = .default
        
        inputTextView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.cornerRadius = 16.0
        inputTextView.layer.masksToBounds = true
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        textViewPadding.right = -77
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 77)
    }
    @objc func specailButtonClick(){
        if let chatVC = delegate as? ChatVC{
            chatVC.addSpecailFeature()
        }
    }
    
    
    func setupLeft(){
        let button = InputBarButtonItem()
        button.addTarget(delegate, action: #selector(specailButtonClick), for: .touchUpInside)
        button.onKeyboardSwipeGesture { item, gesture in
            if gesture.direction == .left {
                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 0, animated: true)
            } else if gesture.direction == .right {
                item.inputBarAccessoryView?.setLeftStackViewWidthConstant(to: 36, animated: true)
            }
        }
        
        button.setSize(CGSize(width: 36, height: 36), animated: false)
        button.setImage(#imageLiteral(resourceName: "ic_plus").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        setLeftStackViewWidthConstant(to: 36, animated: false)
        setStackViewItems([button], forStack: .left, animated: false)
    }
    
    func setupRight(){
        
        let smileButton = InputBarButtonItem()
        smileButton.setSize(CGSize(width: 36, height: 36), animated: false)
        smileButton.setImage(#imageLiteral(resourceName: "anonymous").withRenderingMode(.alwaysTemplate), for: .normal)
        smileButton.imageView?.contentMode = .scaleAspectFit
        smileButton.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        
        
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.image = #imageLiteral(resourceName: "ic_send").withRenderingMode(.alwaysTemplate)
        sendButton.title = nil
        sendButton.tintColor = tintColor
        setRightStackViewWidthConstant(to: 77, animated: false)
        
        // 36 + 36 + 5 = 77
        // InputBarButtonItem.fixedSpace(2)
        setStackViewItems([smileButton,InputBarButtonItem.fixedSpace(5),sendButton], forStack: .right, animated: false)
    }
    
    lazy var collectionView: AttachmentCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return AttachmentCollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    func setupTop(){
        collectionView.intrinsicContentHeight = 80
        collectionView.backgroundColor = UIColor.cyan
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        topStackView.addArrangedSubview(collectionView)
        collectionView.reloadData()
    }
    lazy var adsView: AttachmentCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return AttachmentCollectionView(frame: .zero, collectionViewLayout: layout)
        
    }()
    func setupBottom(){
        adsView.intrinsicContentHeight = 50
        adsView.showsHorizontalScrollIndicator = false
        let viewController = UIApplication.shared.keyWindow!.rootViewController
        let bannerView = GADBannerView()
        bannerView.rootViewController = viewController
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        bannerView.load(GADRequest())
    
        adsView.addSubview(bannerView)
        
        bannerView.frame = CGRect(x: 0, y: 5, width: UIScreen.main.bounds.width, height: 50)
        
        bottomStackView.addArrangedSubview(adsView)
        print(bottomStackView.frame)
    }
    
}



extension GitHawkInputBar: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isFirstLoad && users.count > 0 {
            users[0].isSelected = true
            isFirstLoad = false
        }
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
        cell.user = users[indexPath.section]
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handle)))
        return cell
    }
    
    @objc func handle(_ sender: UIGestureRecognizer){
        let cell = sender.view as! ImageCell
        resetUserSelected()
        cell.user?.isSelected = true
        collectionView.reloadData()
    }
    
}

