import UIKit
class TimeInputView: UIView{
    
    lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
}

extension CGRect{
    var leftHalf: CGRect{
        return CGRect(x: self.minX, y: self.minY, width: self.width / 2, height: self.height)
    }
    var rightHalf: CGRect{
        return CGRect(x: self.midX, y: self.minY, width: self.width / 2, height: self.height)
    }
    
    func slice(num: Int, at: Int) -> CGRect{
        if num == 0{
            return .zero
        }
        assert(at < num)
        let width = self.width / CGFloat(num)
        let height = self.height
        let xPos = CGFloat(at) * width
        let yPos = self.minX
        return CGRect(x: xPos, y: yPos, width: width , height: height)
    }
    
    var center: CGPoint{
        return CGPoint(x: self.midX, y: self.midY)
    }
    var leftTopCorner: CGPoint{
        return CGPoint(x: self.minX, y: self.minY)
    }
    var rightTopCorner: CGPoint{
        return CGPoint(x: self.maxX, y: self.minY)
    }
    
}

extension CGPoint{
    func div(num: CGFloat) -> CGPoint{
        return CGPoint(x: self.x / num, y: self.y / num)
    }
}
