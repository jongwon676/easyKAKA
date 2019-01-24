import UIKit
struct SizeCalculator{
    static func calcLabelSize(string: String, font: UIFont, limitWidth: CGFloat , limitHeight: CGFloat,numberOfLines: Int) -> CGSize{
        let label = UILabel()
        label.font = font
        label.text = string
        label.numberOfLines = numberOfLines
        return label.sizeThatFits(CGSize(width: limitWidth, height: limitHeight))
    }
    
}
