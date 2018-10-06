//
//  Person.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 06/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

class Person {
    
    let name: String?
    let message: String?
    let hasUnreadMessages: Bool
    let online: Bool
    let date: Date?
    
    init(name: String?, message: String?, unread: Bool, online: Bool, date: Date?) {
        self.name = name
        self.message = message
        self.hasUnreadMessages = unread
        self.online = online
        self.date = date
    }

    
}
