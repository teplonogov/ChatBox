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
    func fetchAllConversations() -> NSFetchRequest<Conversation>
    func fetchOnlineConversations() -> NSFetchRequest<Conversation>
    func fetchConversations(withID: String) -> NSFetchRequest<Conversation>
    func fetchUser(withID: String) -> NSFetchRequest<User>
    func fetchOnlineUsers() -> NSFetchRequest<User>
    func fetchMessagesFrom(conversationID: String) -> NSFetchRequest<Message>
}

class FetchRequests: IFetchRequests {

    func fetchAllConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        let onlineSort = NSSortDescriptor(key: "isOnline", ascending: false)
        request.sortDescriptors = [dateSort, onlineSort]
        return request
    }

    func fetchOnlineConversations() -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == YES")
        return request
    }

    func fetchConversations(withID: String) -> NSFetchRequest<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", withID)
        return request
    }

    func fetchUser(withID: String) -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userID == %@", withID)
        return request
    }

    func fetchOnlineUsers() -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == true")
        return request
    }

    func fetchMessagesFrom(conversationID: String) -> NSFetchRequest<Message> {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "conversationID == %@", conversationID)
        let dateSort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [dateSort]
        return request
    }

}
