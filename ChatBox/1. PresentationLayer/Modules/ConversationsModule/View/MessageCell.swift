//
//  MessageCell.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 07/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration: class {
    var messageText: String? {get set}
}

class MessageCell: UITableViewCell, MessageCellConfiguration {

    var messageText: String? {
        didSet {
            messageLabel.text = messageText
        }
    }

    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var bubleView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
