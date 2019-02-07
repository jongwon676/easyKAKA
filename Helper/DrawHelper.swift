import UIKit
import Foundation
struct DrawHelper{
    enum Direction{
        case left
        case right
    }
    static func drawTail(dir: Direction, cornerPoint: CGPoint) -> [CGPoint]{
        
        
        
        let sign:CGFloat = dir == .left ? -1 : 1
        
        let point1 = CGPoint(x: cornerPoint.x, y: cornerPoint.y + 15.div3())
        
        let point2 = CGPoint(x: point1.x + sign * 16.div3(), y: point1.y)
        // curve (point2,point3)
        let point3 = CGPoint(x: point1.x + sign * 18.div3(), y: point1.y  + 4.div3())
        
        let point4 = CGPoint(x: point1.x, y: point1.y +  19.div3())
        
        
        return [point1,point2,point3,point4]
    }
}
