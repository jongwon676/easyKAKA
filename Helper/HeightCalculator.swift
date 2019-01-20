import UIKit
struct HeightCalculator{
    static func labelCalc(string: String, font: UIFont, limitWidth: CGFloat , limitHeight: CGFloat) -> CGFloat{
        let label = UILabel()
        label.font = font
        label.text = string
        return label.sizeThatFits(strin)
    }
}
