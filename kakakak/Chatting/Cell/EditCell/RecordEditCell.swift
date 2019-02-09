import SnapKit
import UIKit

class RecordEditCell: UITableViewCell,EditCellProtocol {
    
    let picker = UIPickerView()
    
    func configure(msg: Message) {
        let minute = msg.duration / 60
        let second = msg.duration % 60
        picker.selectRow(minute, inComponent: 1, animated: false)
        picker.selectRow(second, inComponent: 3, animated: false)
    }
    
    func getEditContent() -> (MessageProcessor.EditContent)? {
        let minute = picker.selectedRow(inComponent: 1)
        let second = picker.selectedRow(inComponent: 3)
        return MessageProcessor.EditContent.duration(minute * 60 + second)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initPicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initPicker()
    }
    

    func initPicker(){
        
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(picker)
        picker.snp.makeConstraints { (mk) in
            mk.left.right.top.bottom.equalTo(self)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension RecordEditCell: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1{
            return 60
        }else if component == 2{
            return 1
        }else if component == 3{
            return 60
        }else {
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            return "\(row)분"
        } else if component == 2{
            return ":"
        }else if component == 3{
            return "\(row)초"
        }else{
            return ""
        }
    }
}
