import UIKit
class RoomCell: UITableViewCell{
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var roomNameLabel: UILabel!
    @IBOutlet var userCountLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var mainUserLabel: UIButton!
    
    static var reuseId: String = "RoomCell"
    
    
     
    
    var room: Room?{
        didSet{
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "a hh시 mm분"
//            dateFormatter.amSymbol = "오전"
//            dateFormatter.pmSymbol = "오후"
//            
//            timeLabel.text = dateFormatter.string(from: room!.currentDate)
//            //유저가 없을경우?
//            let user = (room?.users.first)!
//            userNameLabel.text = user.name
//            if let imageUrl = user.profileImageUrl{
//                userImage.image = UIImage.loadImageFromName(imageUrl)
//            }
//            desc.text = "test 중입니다."
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
