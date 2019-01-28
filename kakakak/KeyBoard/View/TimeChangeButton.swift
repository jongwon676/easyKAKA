import UIKit
import Foundation

protocol TimeButtonProtocol: class {
    func changeTimeWithMinute(minute: Int)
}

@IBDesignable class TimeChangeButton: UIView{
    @IBInspectable var timeText: String = "1"
    fileprivate var minusLabel = UILabel()
    fileprivate var plusLabel = UILabel()
    fileprivate var timeLabel = UILabel()
    
    weak var delegate: TimeButtonProtocol?
    
    var type: TimeButtonType = .minute
    enum TimeButtonType{
        case minute
        case hour
    }
    
    fileprivate lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
    @IBInspectable var ringColor: UIColor = UIColor.clear{
        didSet{
            circleLayer.strokeColor = ringColor.cgColor
        }
    }
    @IBInspectable var textColor: UIColor = UIColor.black{
        didSet{
            minusLabel.textColor = textColor
            plusLabel.textColor = textColor
            timeLabel.textColor = textColor
        }
    }
    @IBInspectable var buttonColor: UIColor = UIColor.green {
        didSet{
            self.backgroundColor = buttonColor
        }
    }
    
    var timeRange:(min: Int, max : Int) = (0,59)
    
    override func prepareForInterfaceBuilder() {
        setUp()
    }
    override func awakeFromNib() {
        setUp()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func layoutSubviews() {
        setUp()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let buttonLayer = CAShapeLayer()
    let circleLayer = CAShapeLayer()
    
    func setUp(){
        
        self.addSubview(timeLabel)
        self.addSubview(minusLabel)
        self.addSubview(plusLabel)
        self.addGestureRecognizer(tapGesture)
        
        minusLabel.text = "-"
        plusLabel.text = "+"
        timeLabel.text = "36"
        
        timeLabel.font = UIFont.systemFont(ofSize: self.frame.height / 4)
        minusLabel.font = UIFont.systemFont(ofSize: self.frame.height / 3)
        plusLabel.font = UIFont.systemFont(ofSize: self.frame.height / 3)
        
        
        
        
        timeLabel.sizeToFit()
        minusLabel.sizeToFit()
        plusLabel.sizeToFit()
        
        timeLabel.center = self.bounds.center
        minusLabel.center = self.bounds.center
        plusLabel.center = self.bounds.center
        
        minusLabel.frame.origin.x = 17
        plusLabel.frame.origin.x = self.frame.width - plusLabel.frame.width - 10
        
        
        
        
        let lineWidth:CGFloat = 15
        let width = self.frame.height + lineWidth
        let height = self.frame.height + lineWidth
        
        let origin = CGPoint(x: (self.frame.width - width) / 2, y: -lineWidth / 2)
//        circleLayer.anchorPoint = CGPoint(x: 0, y: 0)
        circleLayer.path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: width, height: height))).cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
//        circleLayer.strokeColor = UIColor.gray.cgColor
        circleLayer.lineWidth = 15
        self.layer.addSublayer(circleLayer)
        
        
        self.layer.cornerRadius = self.frame.height / 2
//        self.layer.masksToBounds = true
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer){
        let point = gesture.location(in: self)
        let sign = (point.x <= self.frame.width / 2) ? -1 : 1
        if point.x <= self.frame.width / 2 {
            switch type{
            case .hour: delegate?.changeTimeWithMinute(minute: 60 * sign)
            case .minute: delegate?.changeTimeWithMinute(minute: 1 * sign)
            }
        }
    }
}
