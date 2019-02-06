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
            guard let room = room else { return  }
            var another: User?
            var me: User?
            for user in room.users{
                if user.isMe {
                    userImage.image = UIImage.loadImageFromName(user.profileImageUrl ?? "")
                    me = user
                    break
                }else{
                    another = user
                }
            }
            if let title = room.title{
                roomNameLabel.text = title
            }else{
                if room.isGroupChatting {
                    roomNameLabel.text = "그룹채팅"
                }else{
                    if another != nil { roomNameLabel.text = another!.name}
                    else{
                        roomNameLabel.text = "대화상대 없음"
                    }
                }
            }
            userCountLabel.text = String(room.users.count)
            userCountLabel.isHidden = room.users.count <= 1
                
                descLabel.text = "채팅방 시간 ∙ " + Date.timeToStringRoomDisPlay(date: room.currentDate)
            let meName = me?.name ?? "홍길동"
            mainUserLabel.setTitle(meName, for: .normal)
        }
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
