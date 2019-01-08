import UIKit
import InputBarAccessoryView

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
    
    lazy var collectionView: AttachmentCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return AttachmentCollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        inputTextView.placeholder = "Leave a comment"
        inputTextView.keyboardType = .default
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.image = #imageLiteral(resourceName: "ic_send").withRenderingMode(.alwaysTemplate)
        sendButton.title = nil
        sendButton.tintColor = tintColor
        
        
        collectionView.intrinsicContentHeight = 80
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        bottomStackView.addArrangedSubview(collectionView)
        collectionView.reloadData()
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
