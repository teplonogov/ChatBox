//
//  ConversationsListModel.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 15/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import CoreData


protocol IConversationsListModel {
    var communicationService: ICommunicationService { get }
    func setHandler(communicationHandler: CommunicationHandlerDelegate)
    
}

@objc protocol IFRCSetup {
    @objc optional func setupConversationsFetchedResultController() -> NSFetchedResultsController<Conversation>
    @objc optional func setupMessagesFetchedResultController(userID: String) -> NSFetchedResultsController<Message>
}


class ConversationsListModel: IConversationsListModel,IFRCSetup {
    
    var communicationService: ICommunicationService
    
    init(communicationService: ICommunicationService) {
        self.communicationService = communicationService
    }
    
    func setHandler(communicationHandler: CommunicationHandlerDelegate) {
        communicationService.delegate = communicationHandler
    }
    
    func setupConversationsFetchedResultController() -> NSFetchedResultsController<Conversation> {
        let request = communicationService.fetchRequests.fetchAllConversations()
        request.fetchBatchSize = 20
        let mainContext = communicationService.coreDataStack.mainContext
        let fetchResultController = NSFetchedResultsController(fetchRequest: request,
                                                               managedObjectContext: mainContext,
                                                               sectionNameKeyPath: "isOnline",
                                                               cacheName: nil)
        return fetchResultController
    }

    
}
