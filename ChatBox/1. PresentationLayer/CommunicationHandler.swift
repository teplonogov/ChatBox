//
//  CommunicationHandler.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 19/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

protocol CommunicationHandlerDelegate: class {
    func handleError(error: Error)
}

extension CommunicationHandlerDelegate where Self: UIViewController {
    func handleError(error: Error) {
        let alert = UIAlertController(title: "Проблемы с соединением", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
