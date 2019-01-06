import UIKit
import RealmSwift

class User: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var profileImageUrl: String? = ""
    @objc dynamic var isMe: Bool = false
    
    convenience init(name: String, url: String,isMe: Bool){
        self.init()
        self.name = name
        self.profileImageUrl = url
        self.id = UUID().uuidString
        self.isMe = false
    }
    convenience init(preset: Preset){
        self.init()
        self.name = preset.name
        self.profileImageUrl = preset.profileImageUrl
        self.id = UUID().uuidString
        self.isMe = false
    }
}
