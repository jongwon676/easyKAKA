import Foundation
import UIKit
import RealmSwift

class Message: Object {
    //채팅방 시간, [유저], [Message], id
    
    @objc dynamic private var _messageType = MessageType.text.rawValue
    @objc dynamic var owner: User?
    @objc dynamic var creationDate: Date = Date()
    @objc dynamic var sendDate: Date = Date()
    @objc dynamic var messageText: String = ""
    @objc dynamic var messageImageUrl: String = ""
    @objc dynamic var currentDate: Date = Date()
    @objc dynamic var isFirstMessage: Bool = false
    @objc dynamic var isLastMessage: Bool = false
    
    var readUser = List<User>()
    var noReadUser = List<User>()
    
    convenience required init(owner: User,sendDate: Date ,messageText: String){
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
    }
    
    
    var type: MessageType{
        get { return MessageType(rawValue: _messageType)!}
        set { _messageType = newValue.rawValue }
    }
}

