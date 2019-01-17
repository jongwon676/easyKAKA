import UIKit
import RealmSwift
class User: Object{
    
    @objc dynamic var name: String = ""
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var profileImageUrl: String? = ""
    @objc dynamic var isMe: Bool = false
    @objc dynamic var isExited: Bool = false
    
    @objc dynamic var isSelected: Bool = false
    
    enum Properties: String{
        case name,id,profileImageUrl,isMe,creationDate,isExited
    }
    
    public override static func primaryKey() -> String? {
        return Properties.id.rawValue
    }
    
    convenience init(name: String, url: String,isMe: Bool){
        self.init()
        self.name = name
        self.profileImageUrl = url
        self.id = UUID().uuidString
        self.isMe = false
    }
    
    convenience init(preset: Preset,isMe: Bool = false){
        self.init()
        self.name = preset.name
        self.profileImageUrl = preset.profileImageUrl
        self.id = UUID().uuidString
        self.isMe = isMe
    }
    
}
