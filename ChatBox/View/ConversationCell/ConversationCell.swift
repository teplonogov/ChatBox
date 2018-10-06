//
//  ConversationCell.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 06/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Private constants
    
    private let regularMessageFont = UIFont(name: "Futura-Medium", size:13)
    private let noMessagesYetFont = UIFont(name: "Futura-MediumItalic", size:13)
    private let hasUnreadMessageFont = UIFont(name: "Futura-Bold", size:13)
    
    
    // MARK: - ConversationCellConfiguration
    
    var name: String? {
        didSet {
            self.nameLabel.text = name != nil ? name : "Unknown"
        }
    }
    
    var message: String? {
        didSet {
            configureMessageSyle()
            self.messageLabel.text = message == nil ? "No messages yet" : message
        }
    }
    
    var date: Date? {
        willSet {
            //self.dateLabel.text = String(
        }
    }
    
    var online: Bool = false {

        didSet {
            if online {
                self.onlineView.backgroundColor = #colorLiteral(red: 0.2972377241, green: 0.61023283, blue: 0.9433095455, alpha: 1)
            } else {
                self.onlineView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            }
        }
    }
    
    var hasUnreadMessages: Bool = false {
        didSet {
            configureMessageSyle(unread: hasUnreadMessages)
        }
    }
    
    //MARK: - UITableViewCell

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    // MARK: - Helpers
    
    func configureMessageSyle(unread: Bool = false) {
        
        messageLabel.textColor = UIColor.lightGray
        
        guard message != nil else {
            messageLabel.font = noMessagesYetFont
            return
        }
        
        if unread {
            messageLabel.textColor = UIColor.darkGray
            messageLabel.font = hasUnreadMessageFont
        } else {
            messageLabel.font = regularMessageFont
        }
    }
    
}
