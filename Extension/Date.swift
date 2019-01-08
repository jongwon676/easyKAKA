import UIKit
extension Date{
    func currentDateToString() -> String{
        return String(self.timeIntervalSince1970)
    }
    static func timeToStringSecondVersion(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm:ss"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter.string(from: date)
    }
    
    static func timeToString(date: Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter.string(from: date)
    }
}
