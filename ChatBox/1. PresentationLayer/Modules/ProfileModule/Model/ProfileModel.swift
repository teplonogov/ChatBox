//
//  ProfileModel.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 18/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

struct ProfileDisplayModel {
    var name: String
    var description: String
    var avatar: UIImage
}

protocol IProfileModel: class {
    var delegate: ProfileModelDelegate? { get set }
    func fetchUserProfile()
    func saveUserProfile(profile: ProfileDisplayModel, handler: ((Error?) -> Void)?)
}

protocol ProfileModelDelegate: class {
    func recievedUserProfile(profile: ProfileDisplayModel)
}

class ProfileModel: IProfileModel {

    weak var delegate: ProfileModelDelegate?

    let profileService: IProfileService

    init(profileService: IProfileService) {
        self.profileService = profileService
    }

    func fetchUserProfile() {
        profileService.getProfile { (name, description, imageData) in
            let name: String = name ?? "No name"
            let description: String = description ?? ""
            let avatar = UIImage(data: imageData!) ?? #imageLiteral(resourceName: "placeholder-user")
            let profile = ProfileDisplayModel(name: name, description: description, avatar: avatar)
            self.delegate?.recievedUserProfile(profile: profile)
        }
    }

    func saveUserProfile(profile: ProfileDisplayModel, handler: ((Error?) -> Void)?) {

        let imageData = profile.avatar.jpegData(compressionQuality: 1)

        profileService.saveProfile(name: profile.name,
                                   description: profile.description,
                                   avatarData: imageData) { (error) in
            if let unwrappedError = error {
                if let completionHandler = handler {
                    completionHandler(unwrappedError)
                }
            }

            if let completionHandler = handler {
                completionHandler(nil)
            }

        }

    }

}
