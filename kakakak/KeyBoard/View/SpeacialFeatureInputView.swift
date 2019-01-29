import UIKit
import SnapKit
class SpeacialFeatureInputView: UIView,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    
    
    let buttonInfo: [(name: String,image: UIImage)] = [ ("사진",#imageLiteral(resourceName: "enter")),("날짜선",#imageLiteral(resourceName: "enter")),("통화",#imageLiteral(resourceName: "enter")),("음성 메시지",#imageLiteral(resourceName: "enter")),("삭제 메세지",#imageLiteral(resourceName: "enter")),("전송 실패",#imageLiteral(resourceName: "enter")) ]
    lazy var collectionView: UICollectionView = {
       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        self.collectionView.register(SpecailFeatureCell.self, forCellWithReuseIdentifier: SpecailFeatureCell.reuseId)
        collectionView.snp.makeConstraints { (mk) in
            mk.edges.equalTo(self)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 35
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 35, left: 30, bottom: 30, right: 30)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
