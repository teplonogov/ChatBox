//
//  Conversation.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 11/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {

    static func insertConversation(withID: String, in context: NSManagedObjectContext) -> Conversation {
        guard let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation",
                                                                         into: context) as? Conversation else {
            fatalError("Can't insert Conversation")
        }
        conversation.id = withID
        return conversation
    }

    static func findConversation(withID: String, in context: NSManagedObjectContext) -> Conversation? {
        let fetchRequests = FetchRequests()
        let fetchConversationWithId = fetchRequests.fetchConversations(withID: withID)

        do {
            let conversationsWithId = try context.fetch(fetchConversationWithId)
            assert(conversationsWithId.count < 2, "Conversations with id: \(withID) more than 1")
            if !conversationsWithId.isEmpty {
                let conversation = conversationsWithId.first!
                return conversation
            } else {
                return nil
            }
        } catch {
            assertionFailure("Can't fetch conversations. Check correction of fetch")
            return nil
        }
    }

    static func findOrInsertConversation(withID: String, in context: NSManagedObjectContext) -> Conversation {
        guard let conversation = Conversation.findConversation(withID: withID, in: context) else {
            return Conversation.insertConversation(withID: withID, in: context)
        }
        return conversation
    }

    static func findOnlineConversations(in context: NSManagedObjectContext) -> [Conversation]? {
        let fetchRequests = FetchRequests()
        let fetchRequest = fetchRequests.fetchOnlineConversations()
        do {
            let conversations = try context.fetch(fetchRequest)
            return conversations
        } catch {
            assertionFailure("Can't get conversations by a fetch. May be there is an incorrect fetch")
            return nil
        }
    }
}
