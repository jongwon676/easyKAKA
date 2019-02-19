import UIKit
class UserCollectionView: UICollectionView{
    
    //cache화 해놓고 계속 그리자.
    var bgType: BgType?
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let horRadius: CGFloat = 333
        let verRadius: CGFloat = 160 // 타원의 세로 반지름
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
        
        if let bg = bgType {
            bg.getNavUserCountColor().setStroke()
        }else{
            UIColor.gray.setStroke()
        }
        path.lineWidth = 0.5
        
        path.stroke()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = false
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

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}




