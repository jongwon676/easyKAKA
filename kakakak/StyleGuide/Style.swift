import Foundation
import UIKit
class Style{
    
    static let leftMessageToCornerGap:CGFloat = 65
    static let rightMessageToCornerGap:CGFloat = 21
    static let topMessageToCornerGap:CGFloat = 16
    static let tailSize:CGFloat = 5
    static let profileToCornerGap:CGFloat = 2.5
    static let timeLabelToMessageGap:CGFloat = 6
    static let timeLabelToBottomGap:CGFloat = 2.5
    static let messageToMessageGap:CGFloat = 2.5
    
    static let firstMessageGap:CGFloat = 12
    static let moreThanFirstMessageGap: CGFloat = 4
    
    static let basicTopGap:CGFloat = 4
    static let nameLabelBubbleGap:CGFloat = 6
    static let messagePadding:CGFloat = 10
    static let nameLabelProfileGap: CGFloat = 10
    
    static let voicePadding:CGFloat = 12
    static let voiceImageSize:CGFloat = 40
    static let profileImageSize: CGFloat = 40
    static let bubbleWhiteColor: UIColor = UIColor.white
    static let bubbleCornerRadius: CGFloat = 4
    static let checkBoxOffset: CGFloat = 8
    static let checkBoxSize: CGFloat = 20
    
    static let editModeOffset:CGFloat = 30
    
    
    static let limitMessageWidth: CGFloat = UIScreen.main.bounds.width * 0.6
    static let limitUsernameWidth: CGFloat = UIScreen.main.bounds.width * 0.5
    static let readLabelFont: UIFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
    static let timeLabelFont: UIFont = UIFont.systemFont(ofSize: 10)
    static let messageLabelFont: UIFont = UIFont.systemFont(ofSize: 14)
    static let nameLabelFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    static let readLabelColor: UIColor = #colorLiteral(red: 1, green: 0.8784313725, blue: 0.02745098039, alpha: 1)
    static let timeLabelColor: UIColor = #colorLiteral(red: 0.3982269764, green: 0.4544478655, blue: 0.4920632243, alpha: 1)
    
    
    static let rightBubbleColor: UIColor = #colorLiteral(red: 1, green: 0.8784313725, blue: 0.02745098039, alpha: 1)
    static let leftBubbleColor: UIColor = #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1)
    static var allColors: [UIColor] = [
        #colorLiteral(red: 0.6759738326, green: 0.7519567609, blue: 0.8228363395, alpha: 1),#colorLiteral(red: 0.4036078453, green: 0.5147624612, blue: 0.6726379991, alpha: 1),#colorLiteral(red: 0.6230251789, green: 0.7782136202, blue: 0.7085345387, alpha: 1),#colorLiteral(red: 0.3155667186, green: 0.6444244981, blue: 0.6253412962, alpha: 1),#colorLiteral(red: 0.6062427163, green: 0.6949067712, blue: 0.3358732462, alpha: 1),#colorLiteral(red: 0.9974356294, green: 0.7975012064, blue: 0, alpha: 1),#colorLiteral(red: 0.9370688796, green: 0.545337677, blue: 0.3605213165, alpha: 1),#colorLiteral(red: 0.945753634, green: 0.4633948207, blue: 0.4612485766, alpha: 1),#colorLiteral(red: 0.947542727, green: 0.6109959483, blue: 0.7538235784, alpha: 1),#colorLiteral(red: 0.3311565518, green: 0.2505507171, blue: 0.2539487183, alpha: 1),#colorLiteral(red: 0.7881487012, green: 0.7882850766, blue: 0.7881400585, alpha: 1),#colorLiteral(red: 0.290264219, green: 0.2862787843, blue: 0.2861894071, alpha: 1),#colorLiteral(red: 0.2495647371, green: 0.2613680959, blue: 0.4687768817, alpha: 1),#colorLiteral(red: 0.06200163811, green: 0.2145204544, blue: 0.2895205319, alpha: 1),#colorLiteral(red: 0.4810840487, green: 0.5165579915, blue: 0.5830639005, alpha: 1)
    ]
    static var brightColor = [#colorLiteral(red: 0.6759738326, green: 0.7519567609, blue: 0.8228363395, alpha: 1), #colorLiteral(red: 0.7881487012, green: 0.7882850766, blue: 0.7881400585, alpha: 1), #colorLiteral(red: 0.947542727, green: 0.6109959483, blue: 0.7538235784, alpha: 1), #colorLiteral(red: 0.6230251789, green: 0.7782136202, blue: 0.7085345387, alpha: 1), #colorLiteral(red: 0.6062427163, green: 0.6949067712, blue: 0.3358732462, alpha: 1),#colorLiteral(red: 0.9974356294, green: 0.7975012064, blue: 0, alpha: 1)]
    static var darkColor = [#colorLiteral(red: 0.4810840487, green: 0.5165579915, blue: 0.5830639005, alpha: 1), #colorLiteral(red: 0.06200163811, green: 0.2145204544, blue: 0.2895205319, alpha: 1), #colorLiteral(red: 0.3311565518, green: 0.2505507171, blue: 0.2539487183, alpha: 1), #colorLiteral(red: 0.3155667186, green: 0.6444244981, blue: 0.6253412962, alpha: 1), #colorLiteral(red: 0.945753634, green: 0.4633948207, blue: 0.4612485766, alpha: 1), #colorLiteral(red: 0.4036078453, green: 0.5147624612, blue: 0.6726379991, alpha: 1),#colorLiteral(red: 0.290264219, green: 0.2862787843, blue: 0.2861894071, alpha: 1),#colorLiteral(red: 0.2495647371, green: 0.2613680959, blue: 0.4687768817, alpha: 1), #colorLiteral(red: 0.9370688796, green: 0.545337677, blue: 0.3605213165, alpha: 1)]
    static func getBgType(color: UIColor) -> BgType{
        if Style.brightColor.contains(color){
            return BgType.light
        }else if Style.darkColor.contains(color){
            return BgType.dark
        }else{
            return BgType.dark
        }
    }
}

enum BgType{
    case dark
    case light
    
    var dateTextColor: UIColor {
        switch self {
        case .dark:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        case .light:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
    }
    
    var userNameColor: UIColor{
        switch self {
        case .dark:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
        case .light:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
        }
    }
    
    var dateSeparatorColor: UIColor{
        switch self {
        case .dark:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.3)
        case .light:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
    }
    var chattingTimeColor: UIColor{
        switch self {
        case .dark:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)
        case .light:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
    }
    
    func getNavUserCountColor() -> UIColor{
        switch self {
            case .dark:
                let color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
                return color
            
            case .light:
                let color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
                return color 
        }
    }
    
    func barTintColor() -> UIColor{
        switch self {
            case .dark:
                return UIColor.white
            case .light:
                return UIColor.black
        }
    }
   
    
    func getNavTitleColor() -> UIColor{
        switch self {
        case .dark:
            return UIColor.white
        case .light:
            return UIColor.black
        }
    }
    
    
    
}


