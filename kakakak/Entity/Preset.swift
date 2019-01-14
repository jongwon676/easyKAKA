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
    
    public override static func primaryKey() -> String? {
        return Properties.id.rawValue
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
    
    static func add(name: String,image: UIImage,in realm: Realm = try! Realm()){
        let imageName = Date().currentDateToString() + ".jpg"
        image.writeImage(imgName: imageName)
        let item = Preset(name: name, url: imageName)
        try! realm.write {
            realm.add(item)
        }
    }
    func edit(name: String, image: UIImage, in realm: Realm = try! Realm()){
        image.writeImage(imgName: self.profileImageUrl)
        try! realm.write {
            self.name = name
        }
    }
    
    func delete(in realm: Realm = try! Realm()){
        try! realm.write {
            //이미지도 삭제해야됨.
            realm.delete(self)
        }
    }
}
