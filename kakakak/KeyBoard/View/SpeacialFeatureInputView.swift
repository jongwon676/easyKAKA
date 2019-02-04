import UIKit
import SnapKit
class SpeacialFeatureInputView: UIView,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    
    
    let buttonInfo: [(name: String,image: UIImage)] = [ ("사진",#imageLiteral(resourceName: "enter")),("날짜선",#imageLiteral(resourceName: "enter")),("보이스톡",#imageLiteral(resourceName: "enter")),("음성 메시지",#imageLiteral(resourceName: "enter")),("삭제 메세지",#imageLiteral(resourceName: "enter")),("페이스톡",#imageLiteral(resourceName: "enter")) ]
    lazy var collectionView: UICollectionView = {
       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        self.collectionView.register(SpecailFeatureCell.self, forCellWithReuseIdentifier: SpecailFeatureCell.reuseId)
        collectionView.snp.makeConstraints { (mk) in
            mk.edges.equalTo(self)
        }
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.itemSize = CGSize(width: 50, height: 70)
            layout.minimumLineSpacing = 35
            layout.minimumInteritemSpacing = 35
            layout.sectionInset = UIEdgeInsets(top: 35, left: 30, bottom: 30, right: 30)
        }
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpecailFeatureCell.reuseId, for: indexPath) as! SpecailFeatureCell
        let buttonName = buttonInfo[indexPath.row].name
        let buttonImage = buttonInfo[indexPath.row].image
        cell.configure(title: buttonName, image: buttonImage)
        
        
        return cell
    }
    
}
