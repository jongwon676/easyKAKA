import Foundation
import RealmSwift

class Preset: Object{
    
    @objc dynamic var name: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var profileImageUrl: String = ""
    @objc dynamic var creationDate: Date = Date.distantPast
    @objc dynamic var isDeleted: Bool = false
    
    enum Properties: String{
        case name,id,profileImageUrl,isMe,creationDate
    }
    
    public override static func primaryKey() -> String? {
        return Properties.id.rawValue
    }
    
    static func all(in realm: Realm = try! Realm(), include: Set<String> ,exclude: Set<String>, type: RoomAddVC.ControllerType) -> List<Preset>{
        var list = List<Preset>()
        let objects = realm.objects(Preset.self).sorted(byKeyPath: Preset.Properties.creationDate.rawValue)
        
        for obj in objects{
            if type == .create && obj.isDeleted == false{
                list.append(obj)
            }else if type == .invite && obj.isDeleted == false{
                if !exclude.contains(obj.id){
                    list.append(obj)
                }
            }else if type == .exit{ // 나는 퇴장 못 시킴.
                if include.contains(obj.id){
                    list.append(obj)
                }
            }
        }
        
        return list
    }
    
    static func all(in realm: Realm = try! Realm()) -> Results<Preset>{
        return realm.objects(Preset.self).sorted(byKeyPath: Preset.Properties.creationDate.rawValue)
    }
    static func getListAlivePreset(in realm: Realm = try! Realm()) ->Results<Preset>{
        return realm.objects(Preset.self).sorted(byKeyPath: Preset.Properties.name.rawValue).filter("isDeleted == false")
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
        try! realm.write {
            image.writeImage(imgName: self.profileImageUrl)
            self.name = name
        }
    }
    
    func delete(in realm: Realm = try! Realm()){
        try! realm.write {
            self.isDeleted = true
        }
    }
}
