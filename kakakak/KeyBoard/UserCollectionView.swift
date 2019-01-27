import UIKit
class UserCollectionView: UICollectionView{
    
    //cache화 해놓고 계속 그리자.
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("rect draw")
        dump(rect)
        let horRadius: CGFloat = 333
        let verRadius: CGFloat = 225 // 타원의 세로 반지름
        let offset: CGFloat = 5
        let halfCircle: CGFloat = 30
        var points = [CGPoint]()
        
        for x in stride(from: -horRadius  , to: horRadius , by: 1){
            let yZegob = (1.0 - (x * x / (horRadius * horRadius) )) * verRadius * verRadius
            let y = sqrt(yZegob)
            let translateX = x + bounds.width / 2
            let translateY = verRadius + halfCircle + offset - y
            points.append(CGPoint(x: translateX + rect.minX , y: translateY + rect.minY))
        }
        let path = UIBezierPath()
        for idx in 0 ..< points.count{
            if idx == 0{
                path.move(to: points[idx])
            }else{
                path.addLine(to: points[idx])
            }
        }
        path.lineWidth = 0.5
        UIColor.gray.setStroke()
        path.stroke()
    }
}
extension CGRect{
    
    var midPoint: CGPoint{
        let midX = self.midX
        let midY = self.midY
        return CGPoint(x: midX, y: midY)
    }
    
    static func centeredRect(mid: CGPoint, width: CGFloat, height: CGFloat) -> CGRect{
        return CGRect(x: mid.x - width / 2, y: mid.y - height / 2, width: width, height: height)
    }
}




