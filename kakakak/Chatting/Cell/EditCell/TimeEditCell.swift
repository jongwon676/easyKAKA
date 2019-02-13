//
//  TimeEditCell.swift
//  kakakak
//
//  Created by 성용강 on 07/02/2019.
//  Copyright © 2019 성용강. All rights reserved.
//

import UIKit

class TimeEditCell: UITableViewCell,EditCellProtocol {
    
    func configure(msg: Message) {
        timerPicker.date = msg.sendDate
    }
    
    func getEditContent() -> (MessageProcessor.EditContent)? {
        return MessageProcessor.EditContent.dateTime(timerPicker.date)
    }
    
    @objc func changed(){
        
    }
    

    @IBOutlet var timerPicker: UIDatePicker!{
        didSet{
            timerPicker.addTarget(self, action: #selector(changed), for: .valueChanged)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
