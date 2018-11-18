//
//  RootAssembly.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 15/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: serviceAssembly)
    private lazy var serviceAssembly: IServicesAsembly = ServicesAssmbly(coreAssembly: coreAssembly)
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
