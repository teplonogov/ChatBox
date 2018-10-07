//
//  ConversationViewController.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 07/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var user: Person?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noMessagesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let unwrappedUser = user else {
            return
        }
        
        navigationItem.title = unwrappedUser.name
        
        if user?.messageData != nil {
            noMessagesLabel.isHidden = true
        }
        
    }
    

}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.messageData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = MessageCell()
        
        guard let message = user?.messageData?[indexPath.row] else {
            return cell
        }
        
        let cellID = message.incoming ? "InCell" : "OutCell"
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellID) as? MessageCell {
            cell = dequeuedCell
        } else {
            cell = MessageCell(style: .default, reuseIdentifier: cellID)
        }
        
        cell.messageText = message.textMessage
        cell.bubleView.layer.cornerRadius = 15
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
}


