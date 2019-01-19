import UIKit
import RealmSwift

struct RealmProvider{
    
    let configuration: Realm.Configuration
    
    internal init(config: Realm.Configuration) {
        configuration = config
    }
    
    var realm: Realm {
        return try! Realm(configuration: configuration)
    }

    private static let replayConfig = Realm.Configuration(
        fileURL: try! Path.inDocuments("replay.realm"),
        schemaVersion: 1,
        objectTypes: [Message.self,User.self,Room.self]
    )
    
    public static var replayRealm: RealmProvider = {
        return RealmProvider(config: replayConfig)
    }()

}
