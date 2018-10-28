//
//  ThemeManager.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 14/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import UIKit

class ThemeManager {
    
    static let shared = ThemeManager()
    
    private init(){}
    
    func changeThemeTo(color: UIColor) {
        let navBarAppearance = UINavigationBar.appearance()
        
        if color.isEqual(UIColor.nightBlue()) || color.isEqual(UIColor.skyBlue()) {
            
            navBarAppearance.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            navBarAppearance.barTintColor = color
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
            //navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
            UINavigationBar.appearance().barStyle = UIBarStyle.blackOpaque
            
        } else {
            
            navBarAppearance.tintColor = UIColor.skyBlue()
            navBarAppearance.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.skyBlue()]
            //navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.skyBlue()]
            UINavigationBar.appearance().barStyle = UIBarStyle.default
        }
    }
    
}
