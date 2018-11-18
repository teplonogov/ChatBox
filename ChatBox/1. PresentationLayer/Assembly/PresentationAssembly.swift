//
//  PresentationAssembly.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 15/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

protocol IPresentationAssembly {
    func createConversationsListController() -> ConversationsListViewController
    func createProfileController() -> ProfileViewController
    func createThemesViewController() -> ThemesViewController
    func createConversationViewController() -> ConversationViewController
}

class PresentationAssembly: IPresentationAssembly {
    private let serviceAssembly: IServicesAsembly
    init(serviceAssembly: IServicesAsembly) {
        self.serviceAssembly = serviceAssembly
    }
    func createConversationsListController() -> ConversationsListViewController {
        let sb = UIStoryboard(name: "ConversationsList", bundle: nil)
        let model = ConversationsListModel(usersService: serviceAssembly.usersService)
        let conversationsListVC = sb.instantiateViewController(withIdentifier: "list") as! ConversationsListViewController
        conversationsListVC.model = model
        conversationsListVC.presentationAssembly = self
        model.delegate = conversationsListVC
        return conversationsListVC
    }
    func createProfileController() -> ProfileViewController {
        let profileModel = ProfileModel(profileService: serviceAssembly.profileService)
        let profileVC = ProfileViewController(model: profileModel, presentationAssembly: self)
        profileModel.delegate = profileVC
        return profileVC
    }
    func createThemesViewController() -> ThemesViewController {
        return ThemesViewController()
    }
    func createConversationViewController() -> ConversationViewController {
        return ConversationViewController()
    }
}
