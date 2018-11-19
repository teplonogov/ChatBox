//
//  Message.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 11/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import CoreData

extension Message {

    static func insertNewMessage(in context: NSManagedObjectContext) -> Message {
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message",
                                                                         into: context) as? Message else {
            fatalError("Can't create Message entity")
        }
        return message
    }

    static func findMessagesFrom(conversationID: String, in context: NSManagedObjectContext) -> [Message]? {
        let fetchRequests = FetchRequests()
        let request = fetchRequests.fetchMessagesFrom(conversationID: conversationID)
        do {
            let messages = try context.fetch(request)
            return messages
        } catch {
            assertionFailure("Can't fetch messages. Check correction of fetch")
            return nil
        }
    }

}
