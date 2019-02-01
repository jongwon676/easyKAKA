import UIKit
import RealmSwift
import Firebase
import CBFlashyTabBarController
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(try! Path.documents().absoluteString)
        SyncManager.shared.logLevel = .off
//        Firebase.configure()
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-1497706702442314~7743899510")
        TimeZone.ReferenceType.default = TimeZone(abbreviation: "KST")!

        UITabBar.appearance().tintColor = #colorLiteral(red: 0.8922857642, green: 0.5250218511, blue: 0.9140356183, alpha: 1)
        UITabBar.appearance().layer.borderWidth = 0.5
        UITabBar.appearance().layer.borderColor = UIColor.clear.cgColor
        UITabBar.appearance().clipsToBounds = true
//        UITabBar.appearance().layer.shadowColor = UIColor.gray.cgColor
//        UITabBar.appearance().layer.shadowRadius = 2
        if let tbc = self.window?.rootViewController as? UITabBarController{
            

            if let tbItems = tbc.tabBar.items{
                
                
                tbItems[0].image = UIImage(named: "tabBar1")
                tbItems[1].image = UIImage(named: "tabBar2")
                tbItems[2].image = UIImage(named: "tabBar3")
                
//                tbItems[0].title = "등장인물"
//                tbItems[1].title = "대화"
//                tbItems[2].title = "설정"
            }
            
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

