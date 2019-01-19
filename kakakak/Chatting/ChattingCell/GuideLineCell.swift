import UIKit
import SnapKit

class GuideLineCell:UITableViewCell{
    static var reuseId: String = "GuideLineCell"
    lazy var spaceView:UIView =  {
        let view = UIView()
        
        view.addSubview(self)
        view.snp.makeConstraints { (mk) in
            mk.left.right.equalTo(self)
            mk.bottom.equalTo(self)
            mk.height.equalTo(2)
        }
        return view
    }()
    func configure(){
        spaceView.backgroundColor = UIColor.red
    }
}
