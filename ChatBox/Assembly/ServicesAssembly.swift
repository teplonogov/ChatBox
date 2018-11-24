//
//  ServiceAssembly.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 15/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

protocol IServicesAsembly {
    var profileService: IProfileService { get }
    var communicationService: ICommunicationService { get }
    var pixabayService: IPixabayService { get }
}

class ServicesAssmbly: IServicesAsembly {

    private let coreAssembly: ICoreAssembly
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }

    lazy var profileService: IProfileService = ProfileService(profileStorage: self.coreAssembly.profileStorage)
    let name = UserDefaults.standard.string(forKey: "name") ?? UIDevice.current.name
    lazy var communicationService: ICommunicationService = CommunicationService(name: name,
                                                                                communicator: coreAssembly.communicator,
                                                                                stack: coreAssembly.coreDataStack,
                                                                                requests: coreAssembly.fetchRequests)
    
    lazy var pixabayService: IPixabayService = PixabayService(requestSender: coreAssembly.requestSender)
}
