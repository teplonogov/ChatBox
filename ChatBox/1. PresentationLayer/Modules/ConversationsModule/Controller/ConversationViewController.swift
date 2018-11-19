//
//  ConversationViewController.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 07/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {

    var conversation: Conversation!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noMessagesLabel: UILabel!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var messageTextField: UITextField!

    var fetchedResultsController: NSFetchedResultsController<Message>!
    var presentationAssembly: IPresentationAssembly!
    var model: ConversationModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        sendButton.isEnabled = false

        guard let userId = conversation.id else {
            return
        }

        fetchedResultsController = model.setupMessagesFetchedResultController(userID: userId)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {

        }

        setupKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sendButton.layer.cornerRadius = 10
        conversation.hasUnreadMessages = false
        navigationItem.title = conversation.user?.name ?? "No name"
        switchPlaceHolder()
        scrollDown()
    }

    func switchPlaceHolder() {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            return
        }
        if fetchedObjects.isEmpty {
            noMessagesLabel.isHidden = false
        } else {
            noMessagesLabel.isHidden = true
        }
    }

    func scrollDown() {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            return
        }
        if !fetchedObjects.isEmpty {
            let indexPath = IndexPath(row: fetchedObjects.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }

    // MARK: - Actions

    @IBAction func messageTextChanged(_ sender: UITextField) {
        if sender.text == "" {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }

    @IBAction func sendMessageAction(_ sender: UIButton) {
        guard let text = messageTextField.text, let conversationID = conversation.id else {
            return
        }

        noMessagesLabel.isHidden = true

        model.sendMessage(text: text, conversationId: conversationID) { succes, error in
            if succes {
                self.messageTextField.text = ""
                self.sendButton.isEnabled = false
            }
            if let error = error {
                print(error.localizedDescription)
                self.view.endEditing(true)
                let alert = UIAlertController(title: "Ошибка при отправке сообщения",
                                              message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }

    }

    // MARK: - Notifications

    func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWilAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWiilDissapear),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func keyboardWilAppear(_ notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size

        bottomConstraint.constant = keyboardSize.height + 5 - view.safeAreaInsets.bottom

        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
            self.scrollDown()
        }
    }

    @objc private func keyboardWiilDissapear() {
        self.bottomConstraint.constant = 10
        UIView.animate(withDuration: 0) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Keyboard

    func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(gesture:)))
        view.addGestureRecognizer(tapGesture)
        registerNotifications()
    }

    @objc func hideKeyboard(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = fetchedResultsController.object(at: indexPath)

        if message.incoming {
            guard let messageCell = tableView.dequeueReusableCell(withIdentifier: "InCell",
                                                                  for: indexPath) as? MessageCell else {
                return UITableViewCell()
            }
            messageCell.messageText = message.text
            messageCell.bubleView.layer.cornerRadius = 15
            return messageCell
        } else {
            guard let messageCell = tableView.dequeueReusableCell(withIdentifier: "OutCell",
                                                                  for: indexPath) as? MessageCell else {
                return UITableViewCell()
            }
            messageCell.messageText = message.text
            messageCell.bubleView.layer.cornerRadius = 15
            return messageCell
        }

    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

extension ConversationViewController: CommunicatorListDelegate {
    func updateUsers() {
        if !conversation.isOnline {
            sendButton.isEnabled = false
        }
        conversation.hasUnreadMessages = false
        scrollDown()
    }

    func handleError(error: Error) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Connection error", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
