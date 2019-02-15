import UIKit
import Foundation

let defaultItemScale: CGFloat = 0.8
class UserLayout: UICollectionViewFlowLayout{
    var points: [Int: CGFloat] = [:]
    
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        
        if points.isEmpty{
            calculateCoordinates()
        }
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        self.itemSize = CGSize(width: 90, height: 90)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: collectionView!.frame.width / 2, bottom: 0, right: collectionView!.frame.width / 2)
        
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var attributesCopy: [UICollectionViewLayoutAttributes] = []
        for itemAttributes in attributes! {
            let itemAttributesCopy = itemAttributes.copy() as! UICollectionViewLayoutAttributes
            
            changeLayoutAttributes(itemAttributesCopy)
            
            attributesCopy.append(itemAttributesCopy)
        }
        
        return attributesCopy
    }
    
    override class var layoutAttributesClass : AnyClass {
        return UserCollectionLayoutAttributes.self
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func changeLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) {
        
        let collectionCenter = collectionView!.frame.size.width / 2
        let offset = collectionView!.contentOffset.x
        let normalizedCenter = attributes.center.x - offset
        let centerX = Int(attributes.center.x - collectionView!.contentOffset.x)
        
        if points[centerX] != nil{
            attributes.center.y = points[centerX] ?? 0
        }
        
        
        let maxDistance = itemSize.width + minimumLineSpacing
        let actualDistance = abs(collectionCenter - normalizedCenter)
        let scaleDistance = min(actualDistance, maxDistance)
        
        let ratio = (maxDistance - scaleDistance) / maxDistance
        let scale = defaultItemScale + ratio * (1 - defaultItemScale)
        
        let disToCenterRatio = max(min(1.0, actualDistance / 40 - 0.2),0.0)
        
        (attributes as? UserCollectionLayoutAttributes)?.distToCenterRatio = disToCenterRatio
        
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
    }
    
    
    func calculateCoordinates(){
        //타원의 가로세로 비율 2000 : 1250
        let horRadius: CGFloat = 333
        let verRadius: CGFloat = 180 // 타원의 세로 반지름
        let offset: CGFloat = 5
        let halfCircle: CGFloat = 30
        
        for x in stride(from: -horRadius, to: horRadius, by: 1){
            let yZegob = (1.0 - (x * x / (horRadius * horRadius) )) * verRadius * verRadius
            let y = sqrt(yZegob)
            let translateX = x + UIScreen.main.bounds.width / 2
            let translateY = verRadius + halfCircle + offset - y
            let IntX = Int(translateX)
            points[IntX] = translateY
        }
    }
}

