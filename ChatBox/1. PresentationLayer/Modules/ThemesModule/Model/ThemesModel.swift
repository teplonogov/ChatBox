//
//  ThemesModel.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 19/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation


protocol IThemesModel {
    var themes: Themes {get set}
    func setTheme(for vc: ThemesViewController)
}


class ThemesModel: IThemesModel {
    var themes: Themes = Themes()
    
    func setTheme(for vc: ThemesViewController) {
        if let themeData = UserDefaults.standard.object(forKey: "theme") as? Data {
            let themeColor = NSKeyedUnarchiver.unarchiveObject(with: themeData) as? UIColor
            vc.view.backgroundColor = themeColor
        } else {
            vc.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2972377241, green: 0.61023283, blue: 0.9433095455, alpha: 1)
            vc.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    
}
