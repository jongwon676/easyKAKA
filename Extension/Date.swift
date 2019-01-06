import UIKit
extension Date{
    func currentDateToString() -> String{
        return String(self.timeIntervalSince1970)
    }
}
