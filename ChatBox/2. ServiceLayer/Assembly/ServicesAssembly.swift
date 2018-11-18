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
    var usersService: IUsersService { get }
}

class ServicesAssmbly: IServicesAsembly {
    
    
    
    private let coreAssembly: ICoreAssembly
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var profileService: IProfileService = ProfileService(profileStorage: self.coreAssembly.profileStorage)
    lazy var usersService: IUsersService = UsersService()
}
