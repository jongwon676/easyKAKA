import Foundation
import UIKit
import RealmSwift


class Room: Object{
    
    
    
    @objc dynamic var lastActivateDate: Date = Date()
    @objc dynamic var currentDate: Date = Date()
    @objc dynamic var id: String = UUID().uuidString
    
    @objc dynamic var backgroundImageName: String?
    @objc dynamic var backgroundColorHex: String?
    
    
    var users = List<User>()
    var messages = List<Message>()
    
  
    enum Properties: String{
        case lastActivateDate,users,messages,id
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
    func writeBackgroundImage(in realm:Realm =  try! Realm(), imageName: String){
        try! realm.write {
            self.backgroundImageName = imageName
            self.backgroundColorHex = nil
        }
    }
    func writeBackgroundColor(in realm:Realm = try! Realm(),colorHex: String){
        try! realm.write {
            self.backgroundColorHex = colorHex
            self.backgroundImageName = nil
        }
    }
    
    var activateUsers:List<User> {
        let list = List<User>()
        for user in users{
            if user.isExited == false { list.append(user) }
        }
        return list
    }
}
