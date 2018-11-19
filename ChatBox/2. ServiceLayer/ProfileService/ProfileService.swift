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
    func saveProfile(name: String?, description: String?, avatarData: Data? ,completion: ((Error?) -> ())?)
}


class ProfileService: IProfileService {
    
    let profileStorage: IProfileStorage
    
    init(profileStorage: IProfileStorage) {
        self.profileStorage = profileStorage
    }
    
    func getProfile(completion: @escaping (String?, String?, Data?) -> Void) {
        profileStorage.loadProfile { (profile) in
            if let userProfile = profile {
                let name = userProfile.name
                let description = userProfile.descriptionProfile
                let avatarData = userProfile.avatarImage
                DispatchQueue.main.async {
                    completion(name, description, avatarData)
                }
            } else {
                assert(false, "profile is nil")
            }
            
        }
        
        
    }

    
    
    func saveProfile(name: String?, description: String?, avatarData: Data? ,completion: ((Error?) -> ())?) {
        
    
        Profile.getProfile(in: profileStorage.coreDataStack.saveContext) { (profile) in
            if let userProfile = profile {
                userProfile.name = name
                userProfile.descriptionProfile = description
                userProfile.avatarImage = avatarData
                
                //сохраняем в UserDefaults для использования в MultipeerCommunicator
                UserDefaults.standard.set(userProfile.name, forKey: "name")
                
                self.profileStorage.saveProfile { (error) in
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
            } else {
                assert(false, "profile is nil")
            }
            

        }
        

    }
}
