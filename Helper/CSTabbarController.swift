
import UIKit
import Foundation
class CSTabbarController: UITabBarController{
    
    fileprivate func setupTabBar() {
        
  self.tabBar.layer.borderWidth = 0
        self.tabBar.layer.borderColor = UIColor.clear.cgColor
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
        self.tabBar.layer.shadowRadius = 4
        self.tabBar.layer.shadowOpacity = 0.10
        self.tabBar.layer.masksToBounds = false
        self.tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupTabBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBar()
    }
    
}
