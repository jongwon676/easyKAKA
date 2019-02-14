import UIKit
extension UIView {
    
    func setShadowWithCornerRadius(corners : CGFloat){
        
        self.layer.cornerRadius = corners
        
        let shadowPath2 = UIBezierPath(rect: self.bounds)
        
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        
        self.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
        
        self.layer.shadowOpacity = 0.5
        
        self.layer.shadowPath = shadowPath2.cgPath
        
        
        
    }
    
}
