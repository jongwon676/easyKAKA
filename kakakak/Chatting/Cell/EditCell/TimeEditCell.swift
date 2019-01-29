import UIKit

class TimeEditCell: UITableViewCell {
    
    @IBOutlet var datePicker: UIDatePicker!
    var time: Date = Date(){
        didSet{
            datePicker.date = time
        }
    }
//    func getTimeComponent() -> Date{
//        return datePicker.date
//    }
    
//    func dateSelect()  {
//
//        Swift
//
//        //As part of swift 3 apple has removed NS, making things simpler so
//        //new code will be:
//
//        let date = Date()
//        let calendar = Calendar.current
//
//        let year = calendar.component(.year, from: date)
//        let month = calendar.component(.month, from: date)
//        let day = calendar.component(.day, from: date)
//
//
//
//        let date = Date()
//        let calendar = Calendar.current
//
//        let year = calendar.component(.year, from: date)
//        let month = calendar.component(.month, from: date)
//        let day = calendar.component(.day, from: date)
//
//
//        Date
//        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 260))
//        datePicker.datePickerMode = UIDatePicker.Mode.tim
//        datePicker.addTarget(self, action: #selector(dateSelected(datePicker:)), for: UIControl.Event.valueChanged)
//        let alertController = UIAlertController(title: nil, message:"날짜선 추가" , preferredStyle: UIAlertController.Style.actionSheet)
//        alertController.view.addSubview(datePicker)//add subview
//        let okayAction = UIAlertAction(title: "확인", style: .default) { (action) in
//            self.dateSelected(datePicker: datePicker)
//        }
//        alertController.addAction(okayAction)
//        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
//        alertController.view.addConstraint(height);
//        self.present(alertController, animated: true, completion: nil)
//    }
//
//
//    //selected date func
//    @objc func dateSelected(datePicker:UIDatePicker) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy년 MMM월 d일 EEE"
//        let currentDate = datePicker.date
//        //        print(dateFormatter.string(from: currentDate))
//        // "yyyy년 MMM월 d일 EEE"
//        // 2018년 4월 27일 금요일
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
