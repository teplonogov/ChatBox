//
//  ProfileService.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 18/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation

protocol IProfileService {
    func getProfile(completion: @escaping (String?, String?, Data?) -> Void)
    func saveProfile(completion: ((Error?) -> ())?)
}


class ProfileService: IProfileService {
    
    let profileStorage: IProfileStorage
    
    init(profileStorage: IProfileStorage) {
        self.profileStorage = profileStorage
    }
    
    func getProfile(completion: @escaping (String?, String?, Data?) -> Void) {
        profileStorage.loadProfile { (profile) in
            let name = profile?.name
            // почему падает?( если в loadProfile поставить mainContext, то данные приходят, но не те
            let description = profile?.descriptionProfile
            let avatarData = profile?.avatarImage
            completion(name, description, avatarData)
        }
        
        
    }

    
    
    func saveProfile(completion: ((Error?) -> ())?) {
        profileStorage.saveProfile { (error) in
            if let unwrappedError = error {
                if let handler = completion {
                    handler(unwrappedError)
                }
            } else {
                print("Data was saved")
                if let handler = completion {
                    handler(nil)
                }
            }
        }
    }
}
