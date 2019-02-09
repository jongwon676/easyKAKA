import UIKit
class TimeInputView: UIView{
    let orangeColor = #colorLiteral(red: 0.9237803817, green: 0.654075861, blue: 0.2584527731, alpha: 1)
    
    var room: Room?{
        didSet{
            guard let room = self.room else { return }
            let date = room.currentDate
        }
    }
    
    var hourBtn = TimeButton(frame: .zero, type: .hour)
    var minuteBtn = TimeButton(frame: .zero, type: .minute)
    var containerView = UIStackView()
    var ampmControl = UISegmentedControl(items: ["오전","오후"])
    
    init() {
        
        super.init(frame: CGRect.zero)
        self.addSubview(ampmControl)
        ampmControl.snp.makeConstraints { (mk) in
            mk.left.equalTo(self).offset(20)
            mk.right.equalTo(self).inset(20)
            mk.top.equalTo(self).offset(15)
            mk.height.equalTo(30)
        }
        ampmControl.tintColor = orangeColor
        [hourBtn,minuteBtn].forEach { (btn) in
            containerView.addArrangedSubview(btn)
        }
        containerView.axis = .vertical
        
        containerView.isLayoutMarginsRelativeArrangement = true
        
        containerView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        containerView.spacing = 20
        containerView.distribution = .fillEqually
        containerView.backgroundColor = UIColor.white
        self.addSubview(containerView)
        containerView.snp.makeConstraints { (mk) in
            mk.left.bottom.right.equalTo(self)
            mk.top.equalTo(ampmControl.snp.bottom).offset(20)
        }
        self.backgroundColor = .white
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}


class TimeButton: UIView{
    
    var timeData = [Int]()
    let plusButton = UIButton(type: UIButton.ButtonType.system)
    let minusButton = UIButton(type: UIButton.ButtonType.system)
    let numberLabel = UILabel()
    var type: TimeButtonType
    
    @objc func handleMinus(){
        print("minus clicked")
    }
    @objc func handlePlus(){
        print("plus clicked")
    }
    
    enum TimeButtonType{
        case hour
        case minute
    }
    
    func setNumberText(){
        let num = 0
        let timeString = type == .hour ? "시" : "분"
        var attributedString = NSMutableAttributedString(string: "\(num)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45, weight: .regular)])
        attributedString.append(NSAttributedString(string: timeString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)]))
        numberLabel.attributedText = attributedString
    }
    
    fileprivate func setupView() {
        self.backgroundColor = UIColor.white
        let containerView = UIStackView(arrangedSubviews: [
            UIView(),minusButton,UIView(),UIView(),UIView(),numberLabel,UIView(),UIView(),UIView(),plusButton,UIView()
            ])
        
        
        minusButton.addTarget(self, action: #selector(handleMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(handlePlus), for: .touchUpInside)
        minusButton.setTitle("-", for: .normal)
        plusButton.setTitle("+", for: .normal)
        

        
        
        [minusButton,plusButton].forEach { (btn) in
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 43)
            btn.titleLabel?.textColor = #colorLiteral(red: 0.9237803817, green: 0.654075861, blue: 0.2584527731, alpha: 1)
            btn.tintColor = #colorLiteral(red: 0.9237803817, green: 0.654075861, blue: 0.2584527731, alpha: 1)
        }
        
    
        
        
        setNumberText()
        containerView.axis = .horizontal
        containerView.distribution = .equalCentering
        
        self.addSubview(containerView)
        
        // (120 / 989) * wiidth
        containerView.snp.makeConstraints { (mk) in
            mk.edges.equalTo(self)
        }
        self.layer.cornerRadius = 16
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = CGFloat(100) / CGFloat(989) * frame.width
        self.layer.masksToBounds = true
        self.layer.borderColor = #colorLiteral(red: 0.9097049236, green: 0.909860909, blue: 0.9096950889, alpha: 1)
        self.layer.borderWidth = 1
    }
    
    init(frame: CGRect,type: TimeButtonType) {
        self.type = type
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = .hour
        super.init(coder: aDecoder)
        setupView()
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
