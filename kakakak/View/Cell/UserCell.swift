import UIKit

class UserCell: UITableViewCell {

    let checkString: String = "√"
    var checked: Bool = false
    override var isSelected: Bool{
        didSet{
            checkMark.text = isSelected ? checkString : ""
        }
    }
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
    @IBOutlet weak var profile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
