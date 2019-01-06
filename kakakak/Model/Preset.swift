import Foundation
import RealmSwift

class Preset: Object{
    
    @objc dynamic var name: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var profileImageUrl: String = ""
    @objc dynamic var creationDate: Date = Date.distantPast
    
    
    enum Properties: String{
        case name,id,profileImageUrl,isMe,creationDate
    }
    
    static func all(in realm: Realm = try! Realm()) -> Results<Preset>{
        return realm.objects(Preset.self).sorted(byKeyPath: Preset.Properties.creationDate.rawValue)
    }
    
    convenience init(name: String, url: String){
        self.init()
        self.name = name
        self.profileImageUrl = url
        self.id = UUID().uuidString
        self.creationDate = Date.distantPast
    }
    
    static func add(name: String, profileImageUrl: String,in realm: Realm = try! Realm()){
        let item = Preset(name: name, url: profileImageUrl)
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
