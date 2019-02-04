import UIKit

class UserCell: UITableViewCell {

    let checkString: String = "√"
    var checked: Bool = false {
        didSet{
            if checked{
                checkIcon.image = #imageLiteral(resourceName: "userPick")
            }else{
                checkIcon.image = #imageLiteral(resourceName: "userAdd")
            }
        }
    }
    
    override func prepareForReuse() {
        checked = false
    }
    
    @IBOutlet var checkIcon: UIImageView!
    //    override var isSelected: Bool{
//        didSet{ checkMark.text = isSelected ? checkString : "" }
//    }
    
    var user: Preset?{
        didSet{
            nameLabel.text = user?.name
            if let imgName = user?.profileImageUrl{
                profile.image = UIImage.loadImageFromName(imgName)
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkMark: UILabel!
    @IBOutlet weak var profile: UIImageView!{
        didSet{
            profile.cornerRadius = 20.5
            profile.maskToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
