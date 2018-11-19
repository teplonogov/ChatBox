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
    func createThemesViewController(from vc: ConversationsListViewController) -> UINavigationController
    func createConversationViewController() -> ConversationViewController
}

class PresentationAssembly: IPresentationAssembly {
    private let serviceAssembly: IServicesAsembly
    init(serviceAssembly: IServicesAsembly) {
        self.serviceAssembly = serviceAssembly
    }
    func createConversationsListController() -> ConversationsListViewController {
        let sb = UIStoryboard(name: "ConversationsList", bundle: nil)
        let model = ConversationsListModel(communicationService: serviceAssembly.communicationService)
        let conversationsListVC = sb.instantiateViewController(withIdentifier: "list") as! ConversationsListViewController
        conversationsListVC.model = model
        conversationsListVC.presentationAssembly = self
        return conversationsListVC
    }
    func createProfileController() -> ProfileViewController {
        let profileModel = ProfileModel(profileService: serviceAssembly.profileService)
        let profileVC = ProfileViewController(model: profileModel, presentationAssembly: self)
        profileModel.delegate = profileVC
        return profileVC
    }
    func createThemesViewController(from vc: ConversationsListViewController) -> UINavigationController {
        let model = ThemesModel()
        let themesVC = ThemesViewController(model: model, presentationAssembly: self)
        let themesNavigationController = UINavigationController(rootViewController: themesVC)
        themesVC.handler = { (selectedTheme: UIColor) in
            vc.logThemeChanging(selectedTheme: selectedTheme)
            vc.configureAppearance(color: selectedTheme)
            
            DispatchQueue.global(qos: .utility).async {
                let colorData = NSKeyedArchiver.archivedData(withRootObject: selectedTheme) as Data?
                UserDefaults.standard.set(colorData, forKey: "theme")
            }
        }
        return themesNavigationController
    }
    func createConversationViewController() -> ConversationViewController {
        let sb = UIStoryboard(name: "Conversation", bundle: nil)
        let model = ConversationModel(communicationService: serviceAssembly.communicationService)
        let conversationVC = sb.instantiateInitialViewController() as! ConversationViewController
        conversationVC.model = model
        return conversationVC
    }
}
