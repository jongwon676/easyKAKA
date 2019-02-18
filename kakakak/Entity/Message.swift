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
    @objc dynamic var imageHeight = 0
    @objc dynamic var imageWidth = 0
    
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
        msg.owner = owner
        return msg
    }
    static func makeEnterMessage(from: User,to: List<User>) -> Message{
        let msg = Message()
        msg.owner = from
        msg.type = .enter
        var string: String = from.name + "님이 "
        for (idx,user) in to.enumerated(){
            if idx == to.count - 1 {
                string += user.name + "님을 초대했습니다."
            }else{
                string += user.name + "님과 "
            }
        }
        msg.messageText = string
        return msg
    }
    
    static func makeExitMessage(exit: User) -> Message{
        let msg = Message()
        msg.type = .exit
        msg.owner = exit
        msg.messageText = exit.name + "님이 나갔습니다."
        return msg
    }
    
    func getIdent() -> String{
        switch self.type {
            
        case .text:
            return KTextCell.reuseId
            if let isMe = owner?.isMe, isMe == true {
                
                
                if isFirstMessage { return  "textAnother" }
                else { return "textAnotherSecond" }
            }
                
            else{
                if isFirstMessage { return "textMe"}
                else { return  "textMeSecond"}
            }
            
        case .image:
            return KImageCell.reuseId
            if let isMe = owner?.isMe, isMe == true{
                if isFirstMessage {
                    return "imageAnother"
                }else{
                    return "imageAnotherSecond"
                }
                
            }
            else {
                if isFirstMessage{
                    return  "imageMe"
                }else{
                    return "imageMeSecond"
                }
            }
        case .enter:
            return KInviteCell.reuseId
        case .exit:
            return KExitCell.reuseId
            return "exit"
        case .date:
            return KDateCell.reuseId
            return "dateLine"
        case .call:
            return "KCallMessageCell"
            if let isMe = owner?.isMe, isMe == true{
                if isFirstMessage { return "callMessageAnother" }
                else { return "callMessageAnotherSecond"}
            }
            else {
                if isFirstMessage { return  "callMessageMe" }
                else { return "callMessageMeSecond"}
            }
        case .record:
            return KRecordCell.reuseId
            if let isMe = owner?.isMe, isMe == true{
                
                if isFirstMessage { return "recordMessageAnother"}
                else { return  "recordMessageAnotherSecond"}
            }
            else {
                if isFirstMessage { return  "recordMessageMe"}
                else { return "recordMessageMeSecond"}
                
            }
            
        case .delete:
            return KDeleteMessageCell.reuseId
            if let isMe = owner?.isMe, isMe == true{
                if isFirstMessage { return "deleteMessageAnother"}
                else { return  "deleteMessageAnotherSecond"}
            }else{
                if isFirstMessage { return "deleteMessageMe"}
                else { return "deleteMessageMeSecond" }
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

