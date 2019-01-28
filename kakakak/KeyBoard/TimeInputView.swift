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
    var center: CGPoint{
        return CGPoint(x: self.midX, y: self.midY)
    }
}
