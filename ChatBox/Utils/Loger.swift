//
//  Loger.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 24/09/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import UIKit


class Loger {
    
    var fromState = UIApplication.shared.applicationState
    
    var fromStateStringValue: String {
        switch fromState {
        case .active:
            return "Active"
        case .background:
            return "Background"
        case .inactive:
            return "Inactive"
        }
    }
    
    func printAppStateTransition(state: UIApplication.State, nameMethod: String) {
        if fromState != state {
            
            var currentStateStringValue = String()
            
            switch state {
            case .active:
                currentStateStringValue = "Active"
            case .background:
                currentStateStringValue = "Background"
            case .inactive:
                currentStateStringValue = "Inactive"
            }
            
            let stateChanged = " 🔵 App moved from \(fromStateStringValue) to \(currentStateStringValue): \(nameMethod)"
            self.fromState = state
            print(stateChanged)
        }

    }
    
}
