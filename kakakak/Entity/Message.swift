import Foundation
import UIKit
import RealmSwift

class Message: Object,NSCopying {
    //채팅방 시간, [유저], [Message], id
    
    @objc dynamic private var _messageType = MessageType.text.rawValue
    @objc dynamic var owner: User?  // [fromUser, ExitUser]
    @objc dynamic var sendDate: Date = Date()
    @objc dynamic var messageText: String = ""
    @objc dynamic var messageImageUrl: String = ""
    var noReadUser = List<User>()
    @objc dynamic var isFirstMessage: Bool = false
    @objc dynamic var isLastMessage: Bool = false
    @objc dynamic var isSelected: Bool = false
    @objc dynamic var creationDate: Date = Date()
     // 퇴장시에 1전부 감소 시켜야됨.
    
    
    override static func ignoredProperties() -> [String] {
        return ["isFirstMessage","isLastMessage","isSelected"]
    }
    
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
        case voice
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
    
    static func makeEnterMessage(from: User,to: List<User>) -> Message{
        let msg = Message()
        msg.owner = from
        msg.type = .enter
        return msg
    }
    
    static func makeExitMessage(exit: User) -> Message{
        let msg = Message()
        msg.type = .exit
        msg.owner = exit
        return msg
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        let copy: Message = Message()
        copy.type = self.type
        copy._messageType = self._messageType
        copy.isFirstMessage = true
        copy.isLastMessage = true
        copy.messageImageUrl = self.messageImageUrl
        copy.creationDate = self.creationDate
        copy.sendDate = self.sendDate
        
        
        return copy as Any
    }
    static func all(in provider: Realm) -> Results<Message>{
        return provider.objects(Message.self)
            .sorted(byKeyPath: "creationDate")
    }
}

