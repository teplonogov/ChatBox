//
//  ConversationViewController.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 07/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var conversation: Conversation!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noMessagesLabel: UILabel!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = conversation.name ?? "No name"
        sendButton.layer.cornerRadius = 10
        
        switchPlaceHolder()
        sendButton.isEnabled = false
        conversation.hasUnreadMessages = false
        CommunicationManager.shared.delegate = self
        setupKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        scrollDown()
    }
    
    func switchPlaceHolder() {
        if conversation.messagesData.isEmpty {
            noMessagesLabel.isHidden = false
        } else {
            noMessagesLabel.isHidden = true
        }
    }
    

    
    
    func scrollDown() {
        if !conversation.messagesData.isEmpty {
            let indexPath = IndexPath(row: conversation.messagesData.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func messageTextChanged(_ sender: UITextField) {
        if sender.text == "" {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
    
    
    @IBAction func sendMessageAction(_ sender: UIButton) {
        guard let text = messageTextField.text else {
            return
        }
        
        noMessagesLabel.isHidden = true
        
        CommunicationManager.shared.communicator.sendMessage(string: text, to: conversation.userID) { (success, error) in
            
            if success {
                self.messageTextField.text = ""
                self.sendButton.isEnabled = false
            }
            
            if let error = error {
                print(error.localizedDescription)
                self.view.endEditing(true)
                let alert = UIAlertController(title: "Error after trying send message", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    //MARK: - Notifications
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWilAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWiilDissapear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWilAppear(_ notification: NSNotification) {
        guard let info = notification.userInfo, let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
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
    
    
    //MARK: - Keyboard
    
    
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
        return conversation.messagesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: MessageCell
        
        let message = conversation.messagesData[indexPath.row]
        
        switch message {
        case .incoming(let text):
            cell = tableView.dequeueReusableCell(withIdentifier: "InCell", for: indexPath) as! MessageCell
            cell.messageText = text
            
        case .outgoing(let text):
            cell = tableView.dequeueReusableCell(withIdentifier: "OutCell", for: indexPath) as! MessageCell
            cell.messageText = text
            
        }
        
        cell.bubleView.layer.cornerRadius = 15
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
}


extension ConversationViewController: CommunicatorListDelegate {
    func updateUsers() {
        if !conversation.online {
            sendButton.isEnabled = false
        }
        conversation.hasUnreadMessages = false
        tableView.reloadData()
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


