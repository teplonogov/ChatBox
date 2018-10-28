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
    
//    var onlineHeroes = [Person]()
//    var offlineHeroes = [Person]()
    var choosenConversation: Conversation?
    
    var conversations = [Conversation]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let users = TemporaryData.generateData()
//
//        for person in users {
//            if person.online {
//                onlineHeroes.append(person)
//            } else {
//                offlineHeroes.append(person)
//            }
//        }

        
        let nibCell = UINib(nibName: "ConversationCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "ConversationCell")
        
        CommunicationManager.shared.startConnection()
        CommunicationManager.shared.delegate = self
        
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
        
//        let user: Person?
        
//        if indexPath.section == 0 {
//            user = onlineHeroes[indexPath.row]
//        } else {
//            user = offlineHeroes[indexPath.row]
//        }
        
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
//        var heroes = [Person]()
        
//        if indexPath.section == 0 {
//            heroes = onlineHeroes
//        } else {
//            heroes = offlineHeroes
//        }
        
        cell.name = conversations[indexPath.row].name
        cell.message = conversations[indexPath.row].message
        cell.online = conversations[indexPath.row].online
        cell.date = conversations[indexPath.row].date
        cell.hasUnreadMessages = conversations[indexPath.row].hasUnreadMessages
        cell.onlineView.layer.cornerRadius = cell.onlineView.bounds.width/2
        

    }
    
    
}


extension ConversationsListViewController: CommunicatorListDelegate {
    
    func updateUsers() {
        conversations.removeAll()
        for (_, value) in CommunicationManager.shared.conversations {
            conversations.append(value)
        }
        
        conversations.sort(by: sortConversation(first:second:))
        tableView.reloadData()
    }
    
    func handleError(error: Error) {
        print(error.localizedDescription)
    }
    
    
    
}



