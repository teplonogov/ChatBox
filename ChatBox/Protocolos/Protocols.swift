//
//  Protocols.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 06/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import MultipeerConnectivity


// MARK: - Cell Configuration

protocol ConversationCellConfiguration: class {
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
    
}

protocol MessageCellConfiguration: class {
    var messageText: String? {get set}
}


// MARK: - Multithreading

protocol GetSaveProfileProtocol {
    func getProfile(completion: @escaping (UserProfile) -> ())
    func saveProfile(profile: UserProfile, completion: @escaping(Error?) -> ())
}




// MARK: - Communicator

protocol Communicator: class {
    
    var online: Bool? {get set}
    var delegate: CommunicatorDelegate? {get set}
    func sendMessage(string: String, to userID: String, completionHandler:((_ success: Bool, _ error: Error?) -> ())?)
    
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

protocol CommunicatorListDelegate: class {
    func updateUsers()
    func handleError(error: Error)
}
