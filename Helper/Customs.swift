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



import UIKit

class ColorNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRoomListNav()
        configNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        changeGradientImage(orangeGradient: orangeGradient, orangeGradientLocation: orangeGradientLocation)
    }
    
    let whiteGradient = [UIColor.white,UIColor.white]
    let whitelocation = [0.0,1.0]
    
    var orangeGradient = [UIColor(rgb: 0xCFA3FF),UIColor(rgb: 0xFFAEE1)]
    var orangeGradientLocation = [0.0, 1.0]
    
    var isChattingMode: Bool = false
    
    
    lazy var colorView = { () -> UIView in
        let view = UIView()
        view.isUserInteractionEnabled = false
        navigationBar.addSubview(view)
        navigationBar.sendSubviewToBack(view)
        return view
    }()
    
    
    func changeGradientImage(orangeGradient: [UIColor],orangeGradientLocation: [Double] ) {
        // 1 status bar
        
        print("gradient image")
        colorView.frame = CGRect(x: 0, y: -UIApplication.shared.statusBarFrame.height, width: navigationBar.frame.width, height: UIApplication.shared.statusBarFrame.height)
        
        // 2
        colorView.backgroundColor = UIColor(patternImage: gradientImage(withColours: orangeGradient, location: orangeGradientLocation, view: navigationBar).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: navigationBar.frame.size.width/2, bottom: 10, right: navigationBar.frame.size.width/2), resizingMode: .stretch))
        
        // 3 small title background
        navigationBar.setBackgroundImage(gradientImage(withColours: orangeGradient, location: orangeGradientLocation, view: navigationBar), for: .default)

        // 4 large title background  // 이거 없애면 완벽
        if !isChattingMode {
            navigationBar.layer.backgroundColor = UIColor(patternImage: gradientImage(withColours: orangeGradient, location: orangeGradientLocation, view: navigationBar).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: navigationBar.frame.size.width/2, bottom: 10, right: navigationBar.frame.size.width/2), resizingMode: .stretch)).cgColor
        }else{
            navigationBar.layer.backgroundColor = nil
        }
    }
    
    func configNavigationBar() {
        navigationBar.barStyle = .default
        navigationBar.isTranslucent = true
        navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationBar.tintColor = UIColor.white
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func gradientImage(withColours colours: [UIColor], location: [Double], view: UIView) -> UIImage {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5)).0
        gradient.endPoint = (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5)).1
        gradient.locations = location as [NSNumber]
        gradient.cornerRadius = view.layer.cornerRadius
        return UIImage.image(from: gradient) ?? UIImage()
    }
    
    func setRoomListNav(){
        isChattingMode = false
        orangeGradient = [UIColor(rgb: 0xCFA3FF),UIColor(rgb: 0xFFAEE1)]
        orangeGradientLocation = [0.0, 1.0]
        self.changeGradientImage(orangeGradient: orangeGradient, orangeGradientLocation: orangeGradientLocation)
        navigationBar.isTranslucent = false
    }
    func setChattingNAv(color: UIColor){
        
        isChattingMode = true
        self.orangeGradientLocation = [0.0,1.0]
        self.orangeGradient = [color,color]
        self.changeGradientImage(orangeGradient: [color,color], orangeGradientLocation: [0.0,1.0])
        
        navigationBar.isTranslucent = true
    }
    var type: BgType = .dark{
        didSet{
            setNeedsStatusBarAppearanceUpdate()
            self.navigationBar.tintColor = type.barTintColor()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch type {
            case .dark: return .lightContent
            case .light: return .default
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIImage {
    class func image(from layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size,
                                               layer.isOpaque, UIScreen.main.scale)
        
        defer { UIGraphicsEndImageContext() }
        
        // Don't proceed unless we have context
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


class GradientView: UIView
{
    
    
    @IBInspectable var gradientColor1: UIColor = UIColor(rgb: 0xCFA3FF) {
        didSet{
            self.setGradient()
        }
    }
    
    @IBInspectable var gradientColor2: UIColor = UIColor(rgb: 0xFFAEE1) {
        didSet{
            self.setGradient()
        }
    }
    
    @IBInspectable var gradientStartPoint: CGPoint = .zero {
        didSet{
            self.setGradient()
        }
    }
    
    @IBInspectable var gradientEndPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet{
            self.setGradient()
        }
    }
    
    override func awakeFromNib() {
        setGradient()
    }
    override func prepareForInterfaceBuilder() {
        setGradient()
    }
    
    let gradientLayer = CAGradientLayer()
    
    private func setGradient()
    {
        
        gradientLayer.colors = [self.gradientColor1.cgColor, self.gradientColor2.cgColor]
        gradientLayer.startPoint = self.gradientStartPoint
        gradientLayer.endPoint = self.gradientEndPoint
        gradientLayer.frame = self.bounds
        if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer
        {
            topLayer.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradientLayer, at: 0)
//        self.layer.addSublayer(gradientLayer)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.layer.bounds
    }
}



@IBDesignable
class GradientButton: UIButton {
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.layer.bounds
    }
    
    
    
    
}
class AutoLayoutRadiusView: UIView{
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners([.topLeft, .topRight], radius: 16)

    }
}




