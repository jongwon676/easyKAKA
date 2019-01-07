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
    
    
    var readUser = List<User>()
    var noReadUser = List<User>()
    
    
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

