import Foundation
import UIKit
import RealmSwift

class Message: Object,NSCopying {
    //채팅방 시간, [유저], [Message], id
    
    @objc dynamic private var _messageType = MessageType.text.rawValue
    @objc dynamic private var _callType = callType.voiceTry.rawValue
    
    @objc dynamic var owner: User?  // [fromUser, ExitUser]
    @objc dynamic var sendDate: Date = Date()
    @objc dynamic var messageText: String = ""
    @objc dynamic var messageImageUrl: String = ""
    var noReadUser = List<User>()
    @objc dynamic var isFirstMessage: Bool = false
    @objc dynamic var isLastMessage: Bool = false
    @objc dynamic var isSelected: Bool = false
    @objc dynamic var creationDate: Date = Date()
    @objc dynamic var isDelete: Bool = false
    @objc dynamic var isFail: Bool = false
    @objc dynamic var duration: Int = 0
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
        case call
        case record
        case delete
    }
    
    enum callType: String{
        case voiceTry
        case voiceCancel
        case voiceAbsent
        case voiceSuccess
        case faceTry
        case faceCancel
        case faceAbsent
        case faceSuccess
    }
    var durtionString: String{
        let minute = String(self.duration / 60)
        var second = String(self.duration % 60)
        if second.count < 2 { second = ":0" + second }
        else{ second = ":" + second }
        return minute + second
    }
    func getTitleAndCallImage() -> (title: String, image: UIImage){
        switch ctype {
            
            
            case .voiceTry: return ("보이스톡 해요",#imageLiteral(resourceName: "voiceOn"))
            case .voiceCancel: return ("보이스톡 취소",#imageLiteral(resourceName: "voiceOff"))
            case .voiceAbsent: return ("보이스톡 부재중",#imageLiteral(resourceName: "voiceOff"))
            case .voiceSuccess: return ("보이스톡 " + durtionString,#imageLiteral(resourceName: "voiceOn"))
            case .faceTry: return ("페이스톡 해요",#imageLiteral(resourceName: "faceOn"))
            case .faceCancel: return ("페이스톡 취소",#imageLiteral(resourceName: "faceOff"))
            case .faceAbsent: return ("페이스톡 부재중",#imageLiteral(resourceName: "faceOff"))
            case .faceSuccess: return ("페이스톡 " + durtionString,#imageLiteral(resourceName: "faceOn"))
            
            
        }
    }
    
    var type: MessageType{
        get { return MessageType(rawValue: _messageType)!}
        set { _messageType = newValue.rawValue }
    }
    var ctype: callType{
        get { return callType(rawValue: _callType)!}
        set { _callType = newValue.rawValue }
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
    static func makeDeleteMessage(owner: User?,sendDate: Date) -> Message{
        let msg = Message()
        msg.type = .delete
        msg.owner = owner
        msg.sendDate = sendDate
        return msg
    }
    
    
    static func makeEnterMessage(from: User,to: List<User>) -> Message{
        let msg = Message()
        msg.owner = from
        msg.type = .enter
        return msg
    }
    
    static func makeRecordMessage(duration: Int, owner: User) -> Message{
        let msg = Message()
        msg.type = .record
        msg.owner = owner
        msg.duration = duration
        return msg
    }
    static func makeCallMessage(duration: Int, owner: User, ctype: callType) -> Message{
        let msg = Message()
        msg.type = .call
        msg.ctype = ctype
        msg.duration = duration
        return msg
    }
    
    static func makeExitMessage(exit: User) -> Message{
        let msg = Message()
        msg.type = .exit
        msg.owner = exit
        return msg
    }
    
    func getIdent() -> String{
        switch self.type {
            
        case .text:
            if let isMe = owner?.isMe, isMe == true { return "textAnother"}
                
            else{ return  "textMe"}
            
        case .image:
            if let isMe = owner?.isMe, isMe == true{
                return "imageAnother"
            }
            else { return  "imageMe"}
        case .enter:
            return "invite"
        case .exit:
            return "exit"
        case .date:
            return "dateLine"
        case .call:
            if let isMe = owner?.isMe, isMe == true{
                return "callMessageAnother"
            }
            else { return  "callMessageMe"}
        case .record:
            if let isMe = owner?.isMe, isMe == true{
                return "recordMessageAnother"
            }
            else { return  "recordMessageMe"}
            
        case .delete:
            if let isMe = owner?.isMe, isMe == true{
                return "deleteMessageAnother"
            }else{
                return "deleteMessageMe"
            }
        }
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

