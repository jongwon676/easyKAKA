
import UIKit

class UserNameEditCell: UITableViewCell,EditCellProtocol {
    
    

    @IBOutlet var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(msg: Message) {
        if let owner = msg.owner{
            userNameLabel.text = owner.name
        }
    }
}
