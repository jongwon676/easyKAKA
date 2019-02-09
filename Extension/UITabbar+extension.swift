import UIKit
extension UITabBar {
    static let height: CGFloat = 60
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            sizeThatFits.height = UITabBar.height + window.safeAreaInsets.bottom
        } else {
            sizeThatFits.height = UITabBar.height
        }
        return sizeThatFits
    }
}
