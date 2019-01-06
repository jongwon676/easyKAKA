import Foundation
import RealmSwift

class Preset: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var profileImageUrl: String? = ""
    convenience init(name: String, url: String){
        self.init()
        self.name = name
        self.profileImageUrl = url
        self.id = UUID().uuidString
    }
}

class Pereson: Object{
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
class Message: Object{
    //enum 스트링으로 저장하기. 가져와서 다시변환하기
    
}
