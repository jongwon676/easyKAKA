import Foundation
import UIKit
class UserChattingBaseAnotherCell: BaseChat{
    @IBOutlet var timeReadLabel: TimeAndReadLabel!{
        didSet{
            timeReadLabel.text = ""
        }
    }
    
}
