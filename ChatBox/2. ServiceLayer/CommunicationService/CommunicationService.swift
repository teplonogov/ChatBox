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
    func updateUsers(isOnline: Bool?)
    func handleError(error: Error)
}

protocol CommunicatorUpdateDelegate: class {
    func didLostUser(userId: String)
    func didFoundUser(userId: String)
}

class CommunicationService: ICommunicationService {
    weak var delegate: CommunicationHandlerDelegate?
    weak var communicatorDelegate: CommunicatorUpdateDelegate?
    var communicator: Communicator
    var coreDataStack: ICoreDataStack
    var fetchRequests: IFetchRequests

    let storageManager = ProfileStorage()

    init(name: String, communicator: Communicator,
         stack: ICoreDataStack, requests: IFetchRequests) {
        self.communicator = communicator
        self.fetchRequests = requests
        self.coreDataStack = stack
        self.communicator.delegate = self
        self.communicator.startCommunication(name: name)
    }

    func didStartSessions() {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            DispatchQueue.main.sync {
                self.communicator.online = false
            }
            guard let conversations = Conversation.findOnlineConversations(in: saveContext)
                else {
                    DispatchQueue.main.sync {
                        self.communicator.online = true
                    }
                    return
            }
            conversations.forEach { $0.isOnline = false; $0.user?.isOnline = false }
            self.coreDataStack.performSave(context: saveContext, completionHandler: nil)
            DispatchQueue.main.sync {
                self.communicator.online = true
            }
        }
    }

    func didFoundUser(userId: String, userName: String?) {
        let saveContext = CoreDataStack.shared.saveContext
        saveContext.perform {
            guard let user = User.findOrInsertUser(withID: userId, in: saveContext) else {
                return
            }
            let conversation = Conversation.findOrInsertConversation(withID: userId, in: saveContext)
            user.name = userName
            user.isOnline = true
            conversation.isOnline = true
            conversation.user = user
            self.coreDataStack.performSave(context: saveContext, completionHandler: nil)
            DispatchQueue.main.async {
                self.communicatorDelegate?.didFoundUser(userId: userId)
            }
        }
    }

    func didLostUser(userId: String) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {

            let conversation = Conversation.findOrInsertConversation(withID: userId,
                                                                     in: saveContext)
            conversation.isOnline = false
            conversation.user?.isOnline = false

            self.coreDataStack.performSave(context: saveContext, completionHandler: { error in

                if let unwrappedError = error {
                    DispatchQueue.main.async {
                        self.delegate?.handleError(error: unwrappedError)
                    }
                    return
                }

                DispatchQueue.main.async {
                    self.communicatorDelegate?.didLostUser(userId: userId)
                }
            })
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

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
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

    func sendMessage(text: String, conversationID: String, completion: @escaping (Bool, Error?) -> Void) {
        communicator.sendMessage(string: text, to: conversationID, completionHandler: completion)
    }

}
