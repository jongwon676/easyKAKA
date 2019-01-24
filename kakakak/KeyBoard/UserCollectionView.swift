import UIKit
class UserCollectionView: UICollectionView{
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        print("redraw")
        
        
        //타원의 가로세로 비율 2000 : 1250
        let horRadius: CGFloat = 333
        let verRadius: CGFloat = 225 // 타원의 세로 반지름

        let offset: CGFloat = 5
        let halfCircle: CGFloat = 30
        var points = [CGPoint]()
        for x in stride(from: -horRadius, to: horRadius, by: 1){
            var yZegob = (1.0 - (x * x / (horRadius * horRadius) )) * verRadius * verRadius
            var y = sqrt(yZegob)
            var translateX = x + bounds.width / 2
            var translateY = verRadius + halfCircle + offset - y
            points.append(CGPoint(x: translateX, y: translateY))
        }

        var path = UIBezierPath()

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
        var midX = self.midX
        var midY = self.midY
        return CGPoint(x: midX, y: midY)
    }
    
    static func centeredRect(mid: CGPoint, width: CGFloat, height: CGFloat) -> CGRect{
        
        var rect = CGRect(x: mid.x - width / 2, y: mid.y - height / 2, width: width, height: height)
        return rect
    }
}




