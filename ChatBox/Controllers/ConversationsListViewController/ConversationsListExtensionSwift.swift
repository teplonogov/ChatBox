//
//  ConversationsListExtensionSwift.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 14/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

extension ConversationsListViewController {
    
    func transitionToThemesVC() {
        let themesVC = ThemesViewController(nibName: "ThemesViewController", bundle: nil)
        let themesNavigationController = UINavigationController(rootViewController: themesVC)
        
        themesVC.handler = { [weak self] (selectedTheme: UIColor) in
            self?.logThemeChanging(selectedTheme: selectedTheme)
            self?.configureAppearance(color: selectedTheme)
            let colorData = NSKeyedArchiver.archivedData(withRootObject: selectedTheme) as Data?
            UserDefaults.standard.set(colorData, forKey: "theme")
        }
        
        self.present(themesNavigationController, animated: true, completion: nil)
    }
    
}

