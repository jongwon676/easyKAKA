import UIKit
protocol DemandTimeProtocol {
    func addTimeAndWriteDate(second: TimeInterval)
}
class TimeInputView: UIView,DemandTimeProtocol{
    let orangeColor = #colorLiteral(red: 0.9237803817, green: 0.654075861, blue: 0.2584527731, alpha: 1)
    var date: Date?{
        didSet{
            if let date = date{
                ampmControl.selectedSegmentIndex = (date.hour < 12) ? 0 : 1
                
                var hour = date.hour % 12
                if hour == 0 { hour = 12 }
                let minute = date.minute
                
                hourBtn.setNumberText(hour)
                minuteBtn.setNumberText(minute)
            }
        }
    }
    func addTimeAndWriteDate(second: TimeInterval){
        guard let newDate = date?.addingTimeInterval(second) else { return }
        room?.setDate(date: newDate)
    }
    var room: Room?{
        didSet{
            guard let room = self.room else { return }
            self.date = room.currentDate
        }
    }
    lazy var hourBtn: TimeButton = {
       let btn = TimeButton(frame: .zero, type: .hour)
        btn.delegate = self
        return btn
    }()
    lazy var minuteBtn: TimeButton = {
        let btn = TimeButton(frame: .zero, type: .minute)
        btn.delegate = self
        return btn
    }()
    

    var containerView = UIStackView()
    var ampmControl = UISegmentedControl(items: ["오전","오후"])
    @objc func handleAmPm(_ sender: UISegmentedControl){
        guard let date = self.date else { return }
        if sender.selectedSegmentIndex == 0{
            if date.hour >= 12 {
                addTimeAndWriteDate(second: -3600 * 12)
            }
        }else{
            if date.hour < 12 {
                addTimeAndWriteDate(second: 3600 * 12)
            }
        }
    }
    init() {
        
        super.init(frame: CGRect.zero)
        self.addSubview(ampmControl)
        ampmControl.snp.makeConstraints { (mk) in
            mk.left.equalTo(self).offset(20)
            mk.right.equalTo(self).inset(20)
            mk.top.equalTo(self).offset(15)
            mk.height.equalTo(30)
        }
        ampmControl.addTarget(self, action: #selector(handleAmPm), for: .valueChanged)
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
    var delegate: DemandTimeProtocol?

    
    @objc func handleMinus(){
        switch type {
            case .hour: delegate?.addTimeAndWriteDate(second: -3600)
            case .minute: delegate?.addTimeAndWriteDate(second: -60)
        }
        
    }
    @objc func handlePlus(){
        switch type {
        case .hour: delegate?.addTimeAndWriteDate(second: 3600)
        case .minute: delegate?.addTimeAndWriteDate(second: 60)
        }
    }
    
    enum TimeButtonType{
        case hour
        case minute
    }
    
    func setNumberText(_ time: Int){
        let timeString = type == .hour ? "시" : "분"
        var attributedString = NSMutableAttributedString(string: "\(time)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 45, weight: .regular)])
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
        
    
        
        
        setNumberText(0)
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
