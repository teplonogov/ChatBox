//
//  Conversation.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 28/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

class Conversation {

    var name: String?
    var message: String?
    var date: Date?
    var userID: String
    var online: Bool
    var hasUnreadMessages: Bool
    var messagesData: [Message] = []

    init(userID: String, name: String?) {
        self.userID = userID
        self.name = name
        online = true
        hasUnreadMessages = false
    }

    enum Message {
        case incoming(String)
        case outgoing(String)
    }

}
