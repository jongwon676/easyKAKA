import UIKit
@IBDesignable
class CornerRadiusView: UIView{
    func setUp(){
        self.layer.masksToBounds = true
        self.radius = 3
    }
    @IBInspectable var radius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = radius
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
    }
    override func prepareForInterfaceBuilder() {
        setUp()
    }
    override func awakeFromNib() {
        setUp()
    }
}
class ChatRadiusProfileView: UIImageView{
    func setUp(){
        self.layer.masksToBounds = true
        self.radius = 20
    }
    @IBInspectable var radius: CGFloat = 20{
        didSet{
            self.layer.cornerRadius = radius
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
    }
    override func prepareForInterfaceBuilder() {
        setUp()
    }
    override func awakeFromNib() {
        setUp()
    }
}


