//
//  Protocols.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 06/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation


protocol ConversationCellConfiguration: class {
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
    
}

protocol MessageCellConfiguration: class {
    var messageText: String? {get set}
}



protocol GetSaveProfileProtocol {
    func getProfile(completion: @escaping (UserProfile) -> ())
    func saveProfile(profile: UserProfile, completion: @escaping(Error?) -> ())
}
