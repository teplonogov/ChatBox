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


//protocol CommunicatorDelegate: class {
//
//    //discovering
//    func didFoundUser(userID: String, userName: String?)
//    func didLostUser(userID: String)
//
//    //errors
//    func failedToStartBrowsingForUsers(error: Error)
//    func failedToStartAdvertising(error: Error)
//
//    //messages
//    func didRecieveMessage(text: String, fromUser: String, toUser: String)
//
//}

class CommunicationService: ICommunicationService {
    weak var delegate: CommunicationHandlerDelegate?
    var communicator: Communicator
    var coreDataStack: ICoreDataStack
    var fetchRequests: IFetchRequests

    let storageManager = ProfileStorage()

    init(name: String, communicator: Communicator,
         coreDataStack: ICoreDataStack, fetchRequests: IFetchRequests) {
        self.communicator = communicator
        self.fetchRequests = fetchRequests
        self.coreDataStack = coreDataStack
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
            CoreDataStack.shared.performSave(context: saveContext, completionHandler: nil)
        }
    }

    func didLostUser(userId: String) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            
            let conversation = Conversation.findOrInsertConversation(withID: userId,
                                                                     in: saveContext)
            conversation.isOnline = false
            conversation.user?.isOnline = false
            
            self.coreDataStack.performSave(context: saveContext, completionHandler: nil)
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
