//
//  CommunicationManager.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 25/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class CommunicationManager: CommunicatorDelegate {
    
    static let shared = CommunicationManager()
    var conversations = [String : Conversation]()
    let communicator: MultipeerCommunicator
    weak var delegate: CommunicatorListDelegate?
    
    
    private init() {
        communicator = MultipeerCommunicator()
        communicator.delegate = self
    }
    
    func startConnection() {
        communicator.startAdvertiserAndBrowser()
    }
    
    
    
    //MARK: - CommunicatorDelegate
    
    
    func didFoundUser(userID: String, userName: String?) {
        if let conversation = conversations[userID] {
            conversation.online = true
        } else {
            let conversation = Conversation(userID: userID, name: userName)
            conversations[userID] = conversation
            conversation.online = true
        }
        
        if let unwrappedDelegate = delegate {
            DispatchQueue.main.async {
                unwrappedDelegate.updateUsers()
            }
        }
    }
    
    func didLostUser(userID: String) {
        if let conversation = conversations[userID] {
            conversation.online = false
            conversations.removeValue(forKey: userID)
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
        if let conversation = conversations[fromUser] {
            let message = Conversation.Message.incoming(text)
            conversation.messagesData.append(message)
            conversation.date = Date()
            conversation.message = text
            conversation.hasUnreadMessages = true
        } else if let conversation = conversations[toUser] {
            let message = Conversation.Message.outgoing(text)
            conversation.messagesData.append(message)
            conversation.date = Date()
            conversation.message = text
        }
        guard let delegate = delegate else { return }
        DispatchQueue.main.async {
            delegate.updateUsers()
        }
    }
    

}
