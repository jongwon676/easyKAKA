import Foundation
import UIKit
import RealmSwift

class Message: Object {
    //채팅방 시간, [유저], [Message], id
    
    @objc dynamic private var _messageType = MessageType.text.rawValue
    
    @objc dynamic var owner: User?  // [fromUser, ExitUser]
    @objc dynamic var toUser: User? // [toUser]
    
    @objc dynamic var sendDate: Date = Date()
    @objc dynamic var messageText: String = ""
    @objc dynamic var messageImageUrl: String = ""
    
    @objc dynamic var isFirstMessage: Bool = false
    @objc dynamic var isLastMessage: Bool = false
    
    var readUser = List<User>()
    var noReadUser = List<User>()
    

    
    
    convenience required init(owner: User?,sendDate: Date ,messageText: String){
        self.init()
        self.owner = owner
        self.sendDate = sendDate
        self.messageText = messageText
    }
    
    
    
    
    enum MessageType: String{
        case text
        case image
        case enter
        case exit
        case date
        case guide
    }
    
    
    var type: MessageType{
        get { return MessageType(rawValue: _messageType)!}
        set { _messageType = newValue.rawValue }
    }
    
    static func makeImageMessage(owner: User?, sendDate: Date, imageUrl: String) -> Message{
        let msg = Message()
        msg.owner = owner
        msg.sendDate = sendDate
        msg.type = .image
        msg.messageImageUrl = imageUrl
        return msg
    }
    static func makeDateMessage(date: Date = Date()) -> Message{
        let msg = Message()
        msg.owner = nil
        msg.type = .date
        msg.sendDate = date
        return msg
    }
    static func makeEnterMessage(from: User, to: User) -> Message{
        let msg = Message()
        
        msg.owner = from
        msg.toUser = to
        msg.type = .enter

        return msg
    }
    static func makeExitMessage(exit: User) -> Message{
        let msg = Message()
        msg.type = .exit
        msg.owner = exit
        return msg
    }
}

