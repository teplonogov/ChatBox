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
        let themesVC = presentationAssembly.createThemesViewController(fromVC: self)
        self.present(themesVC, animated: true, completion: nil)
    }

}
