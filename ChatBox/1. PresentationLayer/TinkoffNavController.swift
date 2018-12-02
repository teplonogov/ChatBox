//
//  TinkoffNavController.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 02/12/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit

class TinkoffNavController: UINavigationController {
    
    private var animationService: IArmsAnimationService = ArmsAnimationService()

    override func viewDidLoad() {
        super.viewDidLoad()
        animationService.setupView(view: view)
    }

    

}
