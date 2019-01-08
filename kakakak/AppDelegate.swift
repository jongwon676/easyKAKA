import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        var rooms = Room.all()
        var presets = Preset.all()
        
        if rooms.count == 0 && presets.count >= 2{
            var users = List<User>()
            let a = User(preset: presets[0])
            a.isMe = true
            let b = User(preset: presets[1])
            b.isMe = false
            users.append(a)
            users.append(b)
            
            
            
//            var message = Message(owner: users[0], sendDate: Date(), messageText: "야이 쉬벌럼아")
//            var message1 = Message(owner: users[0], sendDate: Date(), messageText: "오키도키염 ㅎㅎㅎ")
//            var message2 = Message(owner: users[1], sendDate: Date(), messageText: "내가 너냐?")
//            var message3 = Message(owner: users[0], sendDate: Date(), messageText: "아 이노무 쉬키가 개빡치게 하네 디지고 싶어? 아니 좀 까불지말고 잇자 그럼 중간은 가니깐")
//            var message4 = Message(owner: users[1], sendDate: Date(), messageText: "야이 쉬벌럼아")
            var messages = List<Message>()
//
//            messages.append(message)
//            messages.append(message1)
//            messages.append(message2)
//            messages.append(message3)
//            messages.append(message4)
//
            Room.add(users: users, messages: messages)
            
            
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

