//
//  DateLineEditCell.swift
//  kakakak
//
//  Created by 성용강 on 06/02/2019.
//  Copyright © 2019 성용강. All rights reserved.
//

import UIKit

class DateLineEditCell: UITableViewCell,EditCellProtocol {
    func getEditContent() -> (MessageProcessor.EditContent)? {
        return MessageProcessor.EditContent.dateLine(datePicker.date)
    }
    
    
    func configure(msg: Message) {
        datePicker.date = msg.sendDate
    }
    
    @IBOutlet var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
