import UIKit
import Foundation
@IBDesignable class TimeChangeButton: UIView{
    @IBInspectable var timeText: String = "1"
    
    var minusLabel = UILabel()
    var plusLabel = UILabel()
    var timeLabel = UILabel()
    
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
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(){
        timeLabel.sizeToFit()
        timeLabel.center = self.bounds.center
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
}
