//
//  ConversationsListViewController.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 06/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ConversationsListViewController: UIViewController {
    
    var choosenConversation: Conversation?
    var conversations = [Conversation]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibCell = UINib(nibName: "ConversationCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "ConversationCell")
        
        CommunicationManager.shared.startConnection()
        conversations.sort(by: sortConversation(first:second:))
    }
    
    
    func sortConversation(first: Conversation, second: Conversation) -> Bool {
        if let firstDate = first.date, let firstName = first.name {
            if let secondDate = second.date, let secondName = first.name {
                if firstDate.timeIntervalSinceNow != secondDate.timeIntervalSinceNow {
                    return firstDate.timeIntervalSinceNow > secondDate.timeIntervalSinceNow
                }
                return firstName > secondName
            }
            return true
        } else {
            return false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CommunicationManager.shared.delegate = self
        updateUsers()
    }
    

    @IBAction func showProfileButton(_ sender: Any) {
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.present(profileVC, animated: true, completion: nil)
    }
    
    @IBAction func showThemesAction(_ sender: Any) {
        transitionToThemesVC()
    }
    
    
    func configureAppearance(color: UIColor) {
        ThemeManager.shared.changeThemeTo(color: color)
    }
    
    func logThemeChanging(selectedTheme: UIColor) {
        print("Color is: \(selectedTheme.description)")
    }
    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chatVC = segue.destination as! ConversationViewController
        chatVC.conversation = choosenConversation
    }
    
    
}


// MARK: - UITableViewDelegate UITableViewDataSource

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: ConversationCell

        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as? ConversationCell {
            cell = dequeuedCell
        } else {
            cell = ConversationCell(style: .default, reuseIdentifier: "ConversationCell")
        }
        
        configureCell(indexPath: indexPath, cell: cell)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.choosenConversation = conversations[indexPath.row]
        performSegue(withIdentifier: "ConversationID", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        }
        
        return "Offline"
    }
    
    
    //MARK: - Helpers
    
    func configureCell(indexPath: IndexPath, cell: ConversationCell) {
        let conversation = conversations[indexPath.row]
        cell.name = conversation.name
        cell.message = conversation.message
        cell.online = conversation.online
        cell.date = conversation.date
        cell.hasUnreadMessages = conversation.hasUnreadMessages
        cell.onlineView.layer.cornerRadius = cell.onlineView.bounds.width/2
    }
    
    
}


extension ConversationsListViewController: CommunicatorListDelegate {
    
    func updateUsers() {
        conversations = Array(CommunicationManager.shared.conversations.values)
        conversations.sort(by: sortConversation(first:second:))
        tableView.reloadData()
    }
    
    func handleError(error: Error) {
        print(error.localizedDescription)
    }
    
    
    
}



