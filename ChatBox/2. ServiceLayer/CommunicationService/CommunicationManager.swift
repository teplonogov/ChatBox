//
//  CommunicationManager.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 25/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol CommunicatorListDelegate: class {
    func updateUsers()
    func handleError(error: Error)
}

protocol CommunicatorDelegate: class {
    
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didRecieveMessage(text: String, fromUser: String, toUser: String)
    
}

class CommunicationManager: CommunicatorDelegate {

    static let shared = CommunicationManager()
    let communicator = MultipeerCommunicator.shared
    weak var delegate: CommunicatorListDelegate?

    let storageManager = ProfileStorage()

    private init() {
        storageManager.loadProfile { (userProfile) in
            guard let profile = userProfile else {
                return
            }
            
            self.communicator.startCommunication(name: nil)
            self.communicator.delegate = self
        }

    }

    // MARK: - CommunicatorDelegate

    func didFoundUser(userID: String, userName: String?) {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            guard let user = User.findOrInsertUser(withID: userID, in: saveContext) else {
                return
            }
            let conversation = Conversation.findOrInsertConversation(withID: userID, in: saveContext)
            user.name = userName
            user.isOnline = true
            conversation.isOnline = true
            conversation.user = user
            CoreDataStack.shared.performSave(context: saveContext, completionHandler: nil)
        }
    }

    func didLostUser(userID: String) {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            let conversation = Conversation.findOrInsertConversation(withID: userID, in: saveContext)
            conversation.isOnline = false
            conversation.user?.isOnline = false
            CoreDataStack.shared.performSave(context: saveContext, completionHandler: nil)
        }
        if let unwrappedDelegate = delegate {
            DispatchQueue.main.async {
                unwrappedDelegate.updateUsers()
            }
        }

    }

    func failedToStartBrowsingForUsers(error: Error) {
        print("Check \(#function), something went wrong")
        if let unwrappedDelegate = delegate {
            DispatchQueue.main.async {
                unwrappedDelegate.handleError(error: error)
            }
        }

    }

    func failedToStartAdvertising(error: Error) {
        print("Check \(#function), something went wrong")
        if let unwrappedDelegate = delegate {
            DispatchQueue.main.async {
                unwrappedDelegate.handleError(error: error)
            }
        }
    }

    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            let message: Message
            if let conversation = Conversation.findConversation(withID: fromUser, in: saveContext) {
                message = Message.insertNewMessage(in: saveContext)
                message.incoming = true
                message.conversationID = conversation.id
                message.text = text
                conversation.date = Date()
                message.date = Date()
                conversation.hasUnreadMessages = true
                conversation.addToMessages(message)
                conversation.lastMessage = message
            } else if let conversation = Conversation.findConversation(withID: toUser, in: saveContext) {
                message = Message.insertNewMessage(in: saveContext)
                message.incoming = false
                message.conversationID = conversation.id
                message.text = text
                conversation.date = Date()
                message.date = Date()
                conversation.hasUnreadMessages = false
                conversation.addToMessages(message)
                conversation.lastMessage = message
            }
            CoreDataStack.shared.performSave(context: saveContext, completionHandler: nil)
        }

    }

}