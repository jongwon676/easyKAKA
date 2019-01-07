import Foundation
import UIKit
import RealmSwift


class Room: Object {
    
    @objc dynamic var lastActivateDate: Date = Date()
    @objc dynamic var currentDate: Date = Date()
    @objc dynamic var id: String = UUID().uuidString
    
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
    
    static func add(in realm: Realm = try! Realm(),users: List<User>){
        let item = Room()
        item.users = users
        try! realm.write {
            realm.add(item)
        }
    }
    
    func delete(in realm: Realm = try! Realm()){
        try! realm.write {
            realm.delete(self)
        }
    }
}
