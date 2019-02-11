import UIKit
extension Date{
    
    func currentDateToString() -> String{
        return String(self.timeIntervalSince1970)
    }
    
    static func timeToStringDateLineVersion(date: Date) -> String{
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday], from: date)
        let DateDict: [Int:String] = [
            1:"일요일",
            2:"월요일",
            3:"화요일",
            4:"수요일",
            5:"목요일",
            6:"금요일",
            7:"토요일",
        ]
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일 \(DateDict[comps.weekday!]!)"
        return dateFormatter.string(from: date)
    }
    
    static func timeToStringRoomDisPlay(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h시 mm분"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter.string(from: date)
    }
    
    static func timeToStringMinuteVersion(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter.string(from: date)
    }
    
    static func ampmSymbol(date: Date) -> String{
        let amPmString = date.hour < 12 ? "오전 " : "오후 "
        return amPmString
    }
    
    static func timeToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        dateFormatter.dateFormat = "a h시 mm분 s초"
        return "\n" + dateFormatter.string(from: date)
    }
    static func isSameDateInChatRoom(date1: Date,date2: Date)->Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:mm"
        return  dateFormatter.string(from: date1) == dateFormatter.string(from: date2)
    }
    
    static func getNavTitle(date: Date) -> String{
        
        let date = date
        let date2 = Date()
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday], from: date)
        
        let comps2 = cal.dateComponents([.weekday], from: date2)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일 a h:mm"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        return dateFormatter.string(from: date)
    }
}
