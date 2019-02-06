//
//  SendFailEditCell.swift
//  kakakak
//
//  Created by 성용강 on 06/02/2019.
//  Copyright © 2019 성용강. All rights reserved.
//

import UIKit

class SendFailEditCell: UITableViewCell,EditCellProtocol {
    func configure(msg: Message) {
        SendFailSwitch.isOn = msg.isFail
    }
    
    @IBOutlet var SendFailSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
