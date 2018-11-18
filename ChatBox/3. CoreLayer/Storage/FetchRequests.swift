//
//  FetchRequestManager.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 11/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import CoreData

protocol IFetchRequests {
    static func fetchAllConversations() -> NSFetchRequest<Conversation>
    static func fetchOnlineConversations() -> NSFetchRequest<Conversation>
    static func fetchConversations(withID: String) -> NSFetchRequest<Conversation>
    static func fetchUser(withID: String) -> NSFetchRequest<User>
    static func fetchOnlineUsers() -> NSFetchRequest<User>
    static func fetchMessagesFrom(conversationID: String) -> NSFetchRequest<Message>
}

class FetchRequests: IFetchRequests {

     static func fetchAllConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        let onlineSort = NSSortDescriptor(key: "isOnline", ascending: false)
        request.sortDescriptors = [dateSort, onlineSort]
        return request
    }

    static func fetchOnlineConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == YES")
        return request
    }

    static func fetchConversations(withID: String) -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", withID)
        return request
    }

    static func fetchUser(withID: String) -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userID == %@", withID)
        return request
    }

    static func fetchOnlineUsers() -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == true")
        return request
    }

    static func fetchMessagesFrom(conversationID: String) -> NSFetchRequest<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "conversationID == %@", conversationID)
        let dateSort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [dateSort]
        return request
    }

}
