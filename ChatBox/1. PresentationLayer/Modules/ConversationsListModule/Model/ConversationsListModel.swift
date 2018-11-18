//
//  ConversationsListModel.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 15/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import CoreData

struct CellDisplayModel {
    let name: String
    let lastMessage: String
    let date: String
    let isOnline: Bool
}

protocol IConversationsListModel: class {
    var delegate: ConversationsListModelDelegate? { get set }
    func fetchOnlineUsers()
}

protocol ConversationsListModelDelegate: class {
    func setup(dataSource: [CellDisplayModel])
}


class ConversationsListModel: IConversationsListModel {

    weak var delegate: ConversationsListModelDelegate?
    
    let usersService: IUsersService
    
    init(usersService: IUsersService) {
        self.usersService = usersService
    }
    
    
    func fetchOnlineUsers() {
        usersService.getUsers {
            guard let unwrappedDelegate = self.delegate else {
                return
            }
            
            //unwrappedDelegate.setup(dataSource: <#T##[CellDisplayModel]#>)
        }
    }
    
}
