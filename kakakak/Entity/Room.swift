import Foundation
import UIKit
import RealmSwift


class Room: Object{
    
    
    
    @objc dynamic var lastActivateDate: Date = Date()
    @objc dynamic var currentDate: Date = Date()
    @objc dynamic var id: String = UUID().uuidString
    
    @objc dynamic var backgroundImageName: String?
    @objc dynamic var backgroundColorHex: String?
    @objc dynamic var title: String?
    @objc dynamic var isGroupChatting: Bool = false
    
    var users = List<User>()
    var messages = List<Message>()
    
    
  
    enum Properties: String{
        case lastActivateDate,users,messages,id,title
    }
    
    public override static func primaryKey() -> String? {
        return Properties.id.rawValue
    }
    
    static func all(in realm:Realm = try! Realm()) -> Results<Room>{
        return realm.objects(Room.self).sorted(byKeyPath: Properties.lastActivateDate.rawValue, ascending: false)
    }
   
    static func add(in realm: Realm = try! Realm(),users: List<User>,messages: List<Message>){
        let item = Room()
        item.users = users
        item.messages = messages
        try! realm.write {
            realm.add(item)
            if users.count > 2 {
                item.isGroupChatting = true
            }
        }
    }
    
    func addMessage(in realm: Realm = try! Realm(), message: Message){
        try! realm.write {
            self.messages.append(message)
        }
    }
    
    func delete(in realm: Realm = try! Realm()){
        try! realm.write {
            realm.delete(self)
        }
    }
    
    func writeBackgroundImage(in realm:Realm =  try! Realm(), image: UIImage){
        let imageName = Date().currentDateToString() + ".jpg"
        if image.writeImage(imgName: imageName){
            try! realm.write {
                self.backgroundImageName = imageName
                self.backgroundColorHex = nil
            }
        }
    }
    
    func writeBackgroundColor(in realm:Realm = try! Realm(),colorHex: String){
        try! realm.write {
            self.backgroundColorHex = colorHex
            self.backgroundImageName = nil
        }
    }
    func setDate(date: Date){
        try! realm?.write {
            currentDate = date
        }
    }
    
    func getRoomTitleName() -> String{
        if title != nil { return title! }
        if isGroupChatting { return "그룹채팅"}
        else{
            for user in users{
                if user.isMe == false { return user.name }
            }
            for user in users{
                return user.name
            }
        }
        return "그룹채팅"
    }
    func getUserNumber() -> String {
        if isGroupChatting {
            return " " + String(users.count)
        }
        return ""
    }
    
    func activeUserId(exceptMe: Bool = true) -> Set<String>{
        var set = Set<String>()
        for user in users{
            if exceptMe == true && user.isMe == true{
                continue
            }
            set.insert(user.presetId)
        }
        return set
    }
    
    
    var activateUsers:List<User> {
        let list = List<User>()
        for user in users{
            if user.isExited == false { list.append(user) }
        }
        return list
    }
    
    func actviateUserExcepteMe(me: User) -> List<User>{
        let list = List<User>()
        for user in users{
            if user.isExited == false && user.id != me.id { list.append(user) }
        }
        return list
    }
    func remove(){
        
        try! realm?.write {
            realm?.delete(users)
            realm?.delete(messages)
            realm?.delete(self)
        }
    }
}
