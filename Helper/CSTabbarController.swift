
import UIKit
import Foundation
class CSTabbarController: UITabBarController{
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOffset = .zero
        self.tabBar.layer.shadowRadius = 2
        self.tabBar.layer.shadowOpacity = 0.3
        self.tabBar.layer.masksToBounds = false        
    }
}
