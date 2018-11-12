//
//  ConversationUser.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 11/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import CoreData

extension ConversationUser {

    static func insertConversation(withID: String, in context: NSManagedObjectContext) -> ConversationUser {
        guard let conversationUser = NSEntityDescription.insertNewObject(forEntityName: "ConversationUser",
                                                                         into: context) as? ConversationUser else {
            fatalError("Can't insert ConversationUser")
        }
        conversationUser.id = withID
        return conversationUser
    }

    static func findConversation(withID: String, in context: NSManagedObjectContext) -> ConversationUser? {
        let fetchConversationWithId = FetchRequestManager.shared.fetchConversations(withID: withID)

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

    static func findOrInsertConversation(withID: String, in context: NSManagedObjectContext) -> ConversationUser {
        guard let conversation = ConversationUser.findConversation(withID: withID, in: context) else {
            return ConversationUser.insertConversation(withID: withID, in: context)
        }
        return conversation
    }

    static func findOnlineConversations(in context: NSManagedObjectContext) -> [ConversationUser]? {
        let fetchRequest = FetchRequestManager.shared.fetchOnlineConversations()
        do {
            let conversations = try context.fetch(fetchRequest)
            return conversations
        } catch {
            assertionFailure("Can't get conversations by a fetch. May be there is an incorrect fetch")
            return nil
        }
    }
}
