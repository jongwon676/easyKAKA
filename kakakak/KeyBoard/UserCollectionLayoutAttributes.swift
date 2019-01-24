import UIKit
class UserCollectionLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var distToCenterRatio:CGFloat = 1.0
    
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! UserCollectionLayoutAttributes
        copy.distToCenterRatio = distToCenterRatio
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? UserCollectionLayoutAttributes {
            if attributes.distToCenterRatio == distToCenterRatio {
                return super.isEqual(object)
            }
        }
        return false
    }
    
}
