//
//  ConversationsListViewController.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 06/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    var onlineHeroes = [Person]()
    var offlineHeroes = [Person]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2972377241, green: 0.61023283, blue: 0.9433095455, alpha: 1)]
        }
        
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.2972377241, green: 0.61023283, blue: 0.9433095455, alpha: 1)
        
        
        
        let venom = Person(name: "Eddie Brock", message: "I'm Venom", unread: true, online: false, date: nil)
        let daredevil = Person(name: "Mattew Murdock", message: "I'm Daredevel", unread: true, online: true, date: nil)
        let cage = Person(name: "Luke Cage", message: "I'm just Luke Cage", unread: false, online: true, date: nil)
        let ironFist = Person(name: "Danny Rand", message: nil, unread: false, online: false, date: nil)
        let spiderMan = Person(name: "Peter Parker", message: "I'm Spider-Man", unread: false, online: true, date: nil)
        
        let heroes = [venom, daredevil, cage, ironFist, spiderMan]
        
        for person in heroes {
            if person.online {
                onlineHeroes.append(person)
            } else {
                offlineHeroes.append(person)
            }
        }

        let nibCell = UINib(nibName: "ConversationCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "ConversationCell")
    }
    

    @IBAction func showProfileButton(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = sb.instantiateViewController(withIdentifier: "ProfileVC")
        self.present(profileVC, animated: true, completion: nil)
    }
    
}


extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return onlineHeroes.count
        } else {
            return offlineHeroes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        var cell: ConversationCell
//
//        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as? ConversationCell {
//            cell = dequeuedCell
//        } else {
//            cell = ConversationCell(style: .default, reuseIdentifier: "ConversationCell")
//        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        
        configureCell(indexPath: indexPath, cell: cell)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    
    //MARK: - Helpers
    
    func configureCell(indexPath: IndexPath, cell: ConversationCell) {
        var heroes = [Person]()
        
        if indexPath.section == 0 {
            heroes = onlineHeroes
        } else {
            heroes = offlineHeroes
        }
        
        cell.name = heroes[indexPath.row].name
        cell.message = heroes[indexPath.row].message
        cell.online = heroes[indexPath.row].online
        cell.hasUnreadMessages = heroes[indexPath.row].hasUnreadMessages
        cell.onlineView.layer.cornerRadius = cell.onlineView.bounds.width/2
        

    }
    
    
    
    
    
}
