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
    
    var userToConversation: Person?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if #available(iOS 11.0, *) {
//            self.navigationController?.navigationBar.prefersLargeTitles = true
//            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2972377241, green: 0.61023283, blue: 0.9433095455, alpha: 1)]
//        }
//
//        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2972377241, green: 0.61023283, blue: 0.9433095455, alpha: 1)
        
        let users = TemporaryData.generateData()
        
        for person in users {
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
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.present(profileVC, animated: true, completion: nil)
    }
    
    @IBAction func showThemesAction(_ sender: Any) {
        let themesVC = ThemesViewController(nibName: "ThemesViewController", bundle: nil)
        let themesNavigationController = UINavigationController(rootViewController: themesVC)
        themesVC.delegate = self
        self.present(themesNavigationController, animated: true, completion: nil)
        
    }
    
    
    func configureAppearance(color: UIColor) {
        ThemeManager.shared.changeThemeTo(color: color)
    }
    

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chatVC = segue.destination as! ConversationViewController
        chatVC.user = userToConversation
    }
    
    
}


// MARK: - UITableViewDelegate UITableViewDataSource

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
        
        let user: Person?
        
        if indexPath.section == 0 {
            user = onlineHeroes[indexPath.row]
        } else {
            user = offlineHeroes[indexPath.row]
        }
        
        if user != nil {
            self.userToConversation = user
            performSegue(withIdentifier: "ConversationID", sender: nil)
        }
        
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
        cell.message = heroes[indexPath.row].messageData?.last?.textMessage
        cell.online = heroes[indexPath.row].online
        cell.date = heroes[indexPath.row].date
        cell.hasUnreadMessages = heroes[indexPath.row].hasUnreadMessages
        cell.onlineView.layer.cornerRadius = cell.onlineView.bounds.width/2
        

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        }
        
        return "Offline"
    }
    
    
    
}

// MARK: - ThemesViewControllerDelegate

extension ConversationsListViewController: ThemesViewControllerDelegate {
    
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
        configureAppearance(color: selectedTheme)
        let colorData = NSKeyedArchiver.archivedData(withRootObject: selectedTheme) as Data?
        UserDefaults.standard.set(colorData, forKey: "theme")
    }
    
    func logThemeChanging(selectedTheme: UIColor) {
        print("Color is: \(selectedTheme.description)")
    }

}
