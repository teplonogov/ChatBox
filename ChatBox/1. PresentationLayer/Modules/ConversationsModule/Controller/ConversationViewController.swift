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
    
    var userNameLabel: UILabel!
    var canSendMessage: Bool = true
    var alreadyAnimated: Bool = false

    var fetchedResultsController: NSFetchedResultsController<Message>!
    var presentationAssembly: IPresentationAssembly!
    var model: ConversationModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableSendButtonWithAnimation()

        guard let userId = conversation.id else {
            return
        }

        fetchedResultsController = model.setupMessagesFetchedResultController(userID: userId)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {

        }
        
        userNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        userNameLabel.text = conversation.user?.name ?? "No name"
        userNameLabel.textAlignment = .center
        userNameLabel.font = UIFont(name: "Futura-medium", size: 20)
        
        model.communicationService.communicatorDelegate = self
        setupKeyboard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sendButton.layer.cornerRadius = 10
        conversation.hasUnreadMessages = false
        navigationItem.titleView = userNameLabel
        switchPlaceHolder()
        scrollDown()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        animateUserNameLabel()
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
            disableSendButtonWithAnimation()
            alreadyAnimated = false
        } else if canSendMessage {
            if alreadyAnimated {
                return
            }
            enableSendButtonWithAnimation()
            alreadyAnimated = true
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
                self.disableSendButtonWithAnimation()
                self.alreadyAnimated = false
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
    
    // MARK: - Animation
    
    
    private func animateScaleSendButton() {
        UIView.transition(with: sendButton, duration: 0.3, options: .curveEaseIn, animations: {
            self.sendButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.transition(with: self.sendButton, duration: 0.3, options: .curveEaseIn, animations: {
                self.sendButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
        })
    }
    
    
    private func disableSendButtonWithAnimation() {
        self.sendButton.isEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.sendButton.alpha = 0.3
        }
        animateScaleSendButton()
    }
    
    private func enableSendButtonWithAnimation() {
        
        self.sendButton.isEnabled = true
        UIView.animate(withDuration: 0.3) {
            self.sendButton.alpha = 1
        }
        animateScaleSendButton()
    }
    
    func animateUserNameLabel() {
        var scale: Double
        var color: UIColor
        if conversation.isOnline {
            scale = 1.1
            color = UIColor.green
        } else {
            scale = 0.9
            color = UIColor.black
        }
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
            self.userNameLabel.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
            self.userNameLabel.textColor = color
        }, completion: nil)
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

extension ConversationViewController: CommunicatorUpdateDelegate {
    func didLostUser(userId: String) {
        if userId == conversation.id {
            conversation.isOnline = false
            canSendMessage = false
            disableSendButtonWithAnimation()
            animateUserNameLabel()
        }
    }
    
    func didFoundUser(userId: String) {
        if userId == conversation.id {
            conversation.isOnline = true
            canSendMessage = true
            animateUserNameLabel()
            if self.messageTextField.text != "" {
                self.enableSendButtonWithAnimation()
            }
        }
    }
    
    

    func handleError(error: Error) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Connection error", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}
