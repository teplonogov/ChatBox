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
    func createThemesViewController(fromVC: ConversationsListViewController) -> TinkoffNavController
    func createConversationViewController() -> ConversationViewController
    func createImageLoaderViewController() -> TinkoffNavController
}

class PresentationAssembly: IPresentationAssembly {
    private let serviceAssembly: IServicesAsembly
    init(serviceAssembly: IServicesAsembly) {
        self.serviceAssembly = serviceAssembly
    }
    func createConversationsListController() -> ConversationsListViewController {
        let sboard = UIStoryboard(name: "ConversationsList", bundle: nil)
        let model = ConversationsListModel(communicationService: serviceAssembly.communicationService)
        let convListVC = sboard.instantiateViewController(withIdentifier: "list") as? ConversationsListViewController
        convListVC?.model = model
        convListVC?.presentationAssembly = self
        return convListVC ?? ConversationsListViewController()
    }
    func createProfileController() -> ProfileViewController {
        let profileModel = ProfileModel(profileService: serviceAssembly.profileService)
        let profileVC = ProfileViewController(model: profileModel, presentationAssembly: self)
        profileModel.delegate = profileVC
        return profileVC
    }
    func createThemesViewController(fromVC: ConversationsListViewController) -> TinkoffNavController {
        let model = ThemesModel()
        let themesVC = ThemesViewController(model: model, presentationAssembly: self)
        let themesNavigationController = TinkoffNavController(rootViewController: themesVC)
        themesVC.handler = { (selectedTheme: UIColor) in
            fromVC.logThemeChanging(selectedTheme: selectedTheme)
            fromVC.configureAppearance(color: selectedTheme)

            DispatchQueue.global(qos: .utility).async {
                let colorData = NSKeyedArchiver.archivedData(withRootObject: selectedTheme) as Data?
                UserDefaults.standard.set(colorData, forKey: "theme")
            }
        }
        return themesNavigationController
    }
    func createConversationViewController() -> ConversationViewController {
        let sboard = UIStoryboard(name: "Conversation", bundle: nil)
        let model = ConversationModel(communicationService: serviceAssembly.communicationService)
        let conversationVC = sboard.instantiateInitialViewController() as? ConversationViewController
        conversationVC?.model = model
        return conversationVC ?? ConversationViewController()
    }

    func createImageLoaderViewController() -> TinkoffNavController {
        let model = ImageLoaderModel(pixabayService: serviceAssembly.pixabayService)
        let imageLoaderVC = ImageLoaderViewController(model: model, presentationAssembly: self)
        model.delegate = imageLoaderVC
        let navController = TinkoffNavController(rootViewController: imageLoaderVC)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}
