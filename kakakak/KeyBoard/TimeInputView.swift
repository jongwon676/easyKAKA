import UIKit
class TimeInputView: UIView{
    
    func getInnerButton() -> UIButton{
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        button.backgroundColor = UIColor.white
        self.addSubview(button)
        return button
    }
    
    lazy var decButton: UIButton = {
        let button = getInnerButton()
        button.setTitle("-", for: .normal)
        self.addSubview(button)
        return button
    }()
    
    lazy var incButton: UIButton = {
        let button = getInnerButton()
        button.setTitle("+", for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        decButton.frame = self.bounds.leftHalf
        incButton.frame = self.bounds.rightHalf
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
