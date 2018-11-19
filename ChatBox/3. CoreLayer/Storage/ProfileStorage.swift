//
//  CoreDataManager.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 06/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation


protocol IProfileStorage {
    func loadProfile(completion: @escaping (Profile?) -> Void)
    func saveProfile(completion: @escaping (Error?) -> Void)
    var coreDataStack: ICoreDataStack {get}
}

class ProfileStorage: IProfileStorage {
    
    var coreDataStack: ICoreDataStack = CoreDataStack.shared

    func loadProfile(completion: @escaping (Profile?) -> Void) {
        Profile.getProfile(in: coreDataStack.mainContext) { (userProfile) in
            if let profile = userProfile {
                DispatchQueue.main.async {
                    completion(profile)
                }
            } else {
                assert(false, "profile is nil")
            }
        }
    }
    
 

    func saveProfile(completion: @escaping (Error?) -> Void) {
        coreDataStack.performSave(context: coreDataStack.saveContext) { (error) in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }

}
