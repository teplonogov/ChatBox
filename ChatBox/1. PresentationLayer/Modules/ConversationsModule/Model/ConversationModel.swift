//
//  ConversationModel.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 19/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import CoreData

typealias IConversationInteractor = IMessageSender & IFRCSetup
protocol IMessageSender {
    var communicationService: ICommunicationService { get }
    func sendMessage(text: String,
                     conversationId: String,
                     completion: @escaping (_ succes: Bool, _ error: Error?) -> Void)
}

class ConversationModel: IConversationInteractor {
    var communicationService: ICommunicationService

    init(communicationService: ICommunicationService) {
        self.communicationService = communicationService
    }

    func sendMessage(text: String,
                     conversationId: String,
                     completion: @escaping (_ succes: Bool, _ error: Error?) -> Void) {
        communicationService.sendMessage(text: text, conversationID: conversationId, completion: completion)
    }

    func setupMessagesFetchedResultController(userID: String) -> NSFetchedResultsController<Message> {
        let request = communicationService.fetchRequests.fetchMessagesFrom(conversationID: userID)
        request.fetchBatchSize = 20
        let mainContext = communicationService.coreDataStack.mainContext
        let fetchResultController = NSFetchedResultsController(fetchRequest: request,
                                                               managedObjectContext: mainContext,
                                                               sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }
}
