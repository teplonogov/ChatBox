//
//  ViewController.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 22/09/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let logger = Logger()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        logger.printControllerLifeCycle(nameMethod: #function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        logger.printControllerLifeCycle(nameMethod: #function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        logger.printControllerLifeCycle(nameMethod: #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logger.printControllerLifeCycle(nameMethod: #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logger.printControllerLifeCycle(nameMethod: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        logger.printControllerLifeCycle(nameMethod: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        logger.printControllerLifeCycle(nameMethod: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        logger.printControllerLifeCycle(nameMethod: #function)
    }


}

