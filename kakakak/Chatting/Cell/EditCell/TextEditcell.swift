//
//  TextEditCell.swift
//  kakakak
//
//  Created by 성용강 on 06/02/2019.
//  Copyright © 2019 성용강. All rights reserved.
//

import UIKit

class TextEditCell: UITableViewCell,EditCellProtocol {
    func getEditContent() -> (MessageProcessor.EditContent)? {
        return MessageProcessor.EditContent.text(messageTextView.text)
    }
    func configure(msg: Message) {
        messageTextView.text = msg.messageText
    }
    
    @IBOutlet var messageTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
