//
//  ConversationsExtension.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 14/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

// MARK: - ThemesViewControllerDelegate

extension ConversationsListViewController: ThemesViewControllerDelegate {
    
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
        configureAppearance(color: selectedTheme)
        let colorData = NSKeyedArchiver.archivedData(withRootObject: selectedTheme) as Data?
        UserDefaults.standard.set(colorData, forKey: "theme")
    }
    
    func transitionToThemesVC() {
        let themesVC = ThemesViewController(nibName: "ThemesViewController", bundle: nil)
        let themesNavigationController = UINavigationController(rootViewController: themesVC)
        themesVC.delegate = self
        self.present(themesNavigationController, animated: true, completion: nil)
    }
    
}
