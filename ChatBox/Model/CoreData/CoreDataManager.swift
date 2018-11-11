//
//  CoreDataManager.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 06/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation


class CoreDataManager {
    
    private let coreDataStack = CoreDataStack.shared
    
    func loadProfile(completion: @escaping (Profile?) -> Void) {
        Profile.getProfile(in: coreDataStack.mainContext) { (userProfile) in
            DispatchQueue.main.async {
                completion(userProfile)
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
