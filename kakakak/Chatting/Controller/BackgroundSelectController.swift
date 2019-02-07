import UIKit
import RealmSwift
class BackgroundSelectController: UICollectionViewController{
    var room : Room?
    var isFirstLoad = true
    var colors: [UIColor] = [
        #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1), #colorLiteral(red: 0.6677912474, green: 0.7560819983, blue: 0.8187431693, alpha: 1),#colorLiteral(red: 0.4036078453, green: 0.5147624612, blue: 0.6726379991, alpha: 1),#colorLiteral(red: 0.6230251789, green: 0.7782136202, blue: 0.7085345387, alpha: 1),#colorLiteral(red: 0.3155667186, green: 0.6444244981, blue: 0.6253412962, alpha: 1),#colorLiteral(red: 0.6062427163, green: 0.6949067712, blue: 0.3358732462, alpha: 1),#colorLiteral(red: 0.9974356294, green: 0.7975012064, blue: 0, alpha: 1),#colorLiteral(red: 0.9370688796, green: 0.545337677, blue: 0.3605213165, alpha: 1),#colorLiteral(red: 0.945753634, green: 0.4633948207, blue: 0.4612485766, alpha: 1),#colorLiteral(red: 0.947542727, green: 0.6109959483, blue: 0.7538235784, alpha: 1),#colorLiteral(red: 0.3311565518, green: 0.2505507171, blue: 0.2539487183, alpha: 1),#colorLiteral(red: 0.7881487012, green: 0.7882850766, blue: 0.7881400585, alpha: 1),#colorLiteral(red: 0.290264219, green: 0.2862787843, blue: 0.2861894071, alpha: 1),#colorLiteral(red: 0.2495647371, green: 0.2613680959, blue: 0.4687768817, alpha: 1),#colorLiteral(red: 0.06200163811, green: 0.2145204544, blue: 0.2895205319, alpha: 1),#colorLiteral(red: 0.4810840487, green: 0.5165579915, blue: 0.5830639005, alpha: 1)
    ]
    let layout = UICollectionViewFlowLayout()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        if isFirstLoad{
            collectionView.selectItem(at: IndexPath(item: 1, section: 0), animated: false, scrollPosition: .top)
            self.collectionView(collectionView, didSelectItemAt: IndexPath(item: 1, section: 0))
            isFirstLoad = false
        }
    }
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(save))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.title = "색상변경"
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.173940599, green: 0.2419398427, blue: 0.3126519918, alpha: 1)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BackgroundCell.self, forCellWithReuseIdentifier: BackgroundCell.reuseId)
        collectionView.register(BackgroundCaptureImageCell.self, forCellWithReuseIdentifier: BackgroundCaptureImageCell.reuseId)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = UIColor.white
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            let width = UIScreen.main.bounds.width
            let side = (width - 3 ) / 3
            layout.itemSize = CGSize(width: side,height: side)
            layout.minimumLineSpacing = 1.5
            layout.minimumInteritemSpacing = 1.5
            layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        }
    }
    var allIndexPaths: [IndexPath] {
        return (0 ..< colors.count).map{
            IndexPath(item: $0, section: 0)
        }
    }
    func getSelectedIndexPath() -> IndexPath?{
        for idx in 0 ..< colors.count{
            let indexPath = IndexPath(item: idx, section: 0)
            
            let cell = (idx == 0) ?  collectionView.cellForItem(at: indexPath) as! BackgroundCaptureImageCell : collectionView.cellForItem(at: indexPath) as! BackgroundCell
            if cell.layer.borderColor == #colorLiteral(red: 0.9991030097, green: 0.9205856323, blue: 0.00153835502, alpha: 1){
                return indexPath
            }
        }
        return nil
    }
    @objc func cancel(){
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @objc func save(){
        if let controller = self.navigationController?.presentingViewController{
            let room = self.room
            let realm = try! Realm()
            
            let indexPath = getSelectedIndexPath()
            if let indexPath = indexPath{
                
                if indexPath.item == 0, let image = (collectionView.cellForItem(at: indexPath) as? BackgroundCaptureImageCell)?.image {
                
                    self.room?.writeBackgroundImage(image: image)
                }
                else {
                    let color = colors[indexPath.item]
                    self.room?.writeBackgroundColor(colorHex: color.toHexString())
                }
                
            }
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func imgPicker(_ source: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    
    
    
    
    
    
}
extension BackgroundSelectController:
UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerPresent(){
        let alert = UIAlertController(title: nil, message: "사진을 가져올 곳을 선택해 주세요.", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "카메라", style: .default) {
                (_) in
                self.imgPicker(.camera)
            })
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default) {
                (_) in
                self.imgPicker(.savedPhotosAlbum)
            })
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default) {
                (_) in
                self.imgPicker(.photoLibrary)
            })
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let topIndexPath = IndexPath(item: 0, section: 0)
        
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            if let cell = collectionView.cellForItem(at: topIndexPath) as? BackgroundCaptureImageCell{
                allIndexPaths.forEach{ deselectIndexPath(indexPath: $0) }
                selectIndexPath(indexPath: topIndexPath)
                cell.image = img
            }
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}


extension BackgroundSelectController:UICollectionViewDelegateFlowLayout{
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackgroundCaptureImageCell.reuseId, for: indexPath)
            cell.backgroundColor = UIColor.clear
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackgroundCell.reuseId, for: indexPath)
            cell.backgroundColor = colors[indexPath.item]
            return cell
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        if indexPath.item == 0{
            imagePickerControllerPresent()
        }
        else{
            allIndexPaths.forEach{ deselectIndexPath(indexPath: $0) }
            selectIndexPath(indexPath: indexPath)
        }
    }
    
    func selectIndexPath(indexPath: IndexPath){
        if let cell = collectionView.cellForItem(at: indexPath){
            cell.layer.borderColor = #colorLiteral(red: 0.9991030097, green: 0.9205856323, blue: 0.00153835502, alpha: 1)
            cell.layer.borderWidth = 3
        }
    }
    func deselectIndexPath(indexPath: IndexPath){
        if let cell = collectionView.cellForItem(at: indexPath){
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0
        }
    }
}
