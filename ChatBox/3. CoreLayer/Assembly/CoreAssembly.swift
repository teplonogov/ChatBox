//
//  CoreAssembly.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 15/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var profileStorage: IProfileStorage { get }
    var coreDataStack: ICoreDataStack { get }
    var communicator: Communicator { get }
    var fetchRequests: IFetchRequests { get }

}

class CoreAssembly: ICoreAssembly {
    lazy var profileStorage: IProfileStorage = ProfileStorage()
    lazy var coreDataStack: ICoreDataStack = CoreDataStack.shared
    lazy var communicator: Communicator = MultipeerCommunicator.shared
    lazy var fetchRequests: IFetchRequests = FetchRequests()
}
