//
//  FetchRequestManager.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 11/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import CoreData


class FetchRequestManager {
    
    static let shared = FetchRequestManager()
    private init() {}
    
    
    func fetchAllConversations() -> NSFetchRequest<ConversationUser> {
        let request: NSFetchRequest<ConversationUser> = ConversationUser.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        let onlineSort = NSSortDescriptor(key: "isOnline", ascending: false)
        request.sortDescriptors = [dateSort, onlineSort]
        return request
    }
    
    
    func fetchOnlineConversations() -> NSFetchRequest<ConversationUser> {
        let request: NSFetchRequest<ConversationUser> = ConversationUser.fetchRequest()
        request.predicate = NSPredicate(format: "isOnline == YES")
        return request
    }
    
    func fetchConversationsWith(id: String) -> NSFetchRequest<ConversationUser> {
        let request: NSFetchRequest<ConversationUser> = ConversationUser.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        return request
    }
    
    func fetchUserWith(id: String) -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "userID == %@", id)
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
