//
//  IComminicationService.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 19/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

protocol ICommunicationService: class, IUserDiscover, ICommunicationFailHandler, IMessageHandler {

    var delegate: CommunicationHandlerDelegate? { get set }
    var communicatorDelegate: CommunicatorUpdateDelegate? { get set }
    var communicator: Communicator { get }
    var coreDataStack: ICoreDataStack { get }
    var fetchRequests: IFetchRequests { get }

    func didStartSessions()
}

protocol IUserDiscover {
    func didFoundUser(userId: String, userName: String?)
    func didLostUser(userId: String)
}

protocol ICommunicationFailHandler {
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
}

protocol IMessageHandler {
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    func sendMessage(text: String,
                     conversationID: String,
                     completion: @escaping (_ succes: Bool, _ error: Error?) -> Void)
}
