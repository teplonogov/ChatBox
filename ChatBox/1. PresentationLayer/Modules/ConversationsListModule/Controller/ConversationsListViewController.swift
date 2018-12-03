//
//  ConversationsListViewController.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 06/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData

class ConversationsListViewController: UIViewController, CommunicationHandlerDelegate {

    var fetchedResultsController: NSFetchedResultsController<Conversation>!

    var presentationAssembly: IPresentationAssembly!
    var model: ConversationsListModel!

    var choosenConversation: Conversation?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let nibCell = UINib(nibName: "ConversationCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "ConversationCell")

        fetchedResultsController = model.setupConversationsFetchedResultController()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            assertionFailure("Error. Need perform fetch on fetchResultController")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        model.setHandler(communicationHandler: self)
    }

    @IBAction func showProfileButton(_ sender: Any) {
        let profileVC = presentationAssembly.createProfileController()
        self.present(profileVC, animated: true, completion: nil)
    }

    @IBAction func showThemesAction(_ sender: Any) {
        transitionToThemesVC()
    }

    func configureAppearance(color: UIColor) {
        ThemeService.shared.changeThemeTo(color: color)
    }

    func logThemeChanging(selectedTheme: UIColor) {
        print("Color is: \(selectedTheme.description)")
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConversationID" {
            let chatVC = segue.destination as? ConversationViewController
            chatVC?.conversation = choosenConversation
        }

    }

}

// MARK: - UITableViewDelegate UITableViewDataSource

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
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
        self.choosenConversation = fetchedResultsController.object(at: indexPath)
        let conversationVC = presentationAssembly.createConversationViewController()
        let conversation = fetchedResultsController.object(at: indexPath)
        conversationVC.conversation = conversation
        self.navigationController?.pushViewController(conversationVC, animated: true)

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else {
            return nil
        }
        return sections[section].name == "1" ? "Online" : "Offline"
    }

    // MARK: - Helpers

    func configureCell(indexPath: IndexPath, cell: ConversationCell) {
        let conversation = fetchedResultsController.object(at: indexPath)
        cell.name = conversation.user?.name
        cell.message = conversation.lastMessage?.text
        cell.online = conversation.isOnline
        cell.date = conversation.date
        cell.hasUnreadMessages = conversation.hasUnreadMessages
        cell.onlineView.layer.cornerRadius = cell.onlineView.bounds.width/2
    }

}

extension ConversationsListViewController: CommunicatorListDelegate {

    func updateUsers(isOnline: Bool?) {
        //used before coredata
    }

    func handleError(error: Error) {
        print(error.localizedDescription)
    }

}
