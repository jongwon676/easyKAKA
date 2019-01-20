import UIKit
struct HeightCalculator{
    static func calcLabel(string: String, font: UIFont, limitWidth: CGFloat , limitHeight: CGFloat,numberOfLines: Int) -> CGSize{
        let label = UILabel()
        label.font = font
        label.text = string
        label.numberOfLines = numberOfLines
        return label.sizeThatFits(CGSize(width: limitWidth, height: limitHeight))
    }
}
