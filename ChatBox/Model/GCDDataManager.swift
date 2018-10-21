//
//  GCDDataManager.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 20/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation


class GCDDataManager: GetSaveProfileProtocol {
    
    let fileDirectory: URL
    let archiveURL: URL

    init() {
        fileDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        archiveURL = fileDirectory.appendingPathComponent("profile").appendingPathExtension("plist")
    }
    
    
    
    // MARK: - GetSaveProfileProtocol
    
    
    func getProfile(completion: @escaping (UserProfile) -> ()) {
        
        DispatchQueue.global(qos: .utility).async {
            let name = UserDefaults.standard.string(forKey: "user_name") ?? "No name"
            let description = UserDefaults.standard.string(forKey: "user_description") ?? ""
            let image: UIImage
            
            if let imageData = try? Data(contentsOf: self.archiveURL), UIImage(data: imageData) != nil {
                image = UIImage(data: imageData)!
            } else {
                image = UIImage(named: "placeholder-user")!
            }
            
            let profile = UserProfile(name: name, description: description, avatar: image)
            
            DispatchQueue.main.async {
                completion(profile)
            }
        }
        
    }
    
    func saveProfile(profile: UserProfile, nameChanged: Bool, descriptionChanged: Bool, avatarChanged: Bool, completion: @escaping (Error?) -> ()) {
        
        DispatchQueue.global(qos: .utility).async {
            sleep(1)
            
            if nameChanged {
                UserDefaults.standard.set(profile.name, forKey: "user_name")
            }
            
            if descriptionChanged {
                UserDefaults.standard.set(profile.description, forKey: "user_description")
            }
            
            if avatarChanged {
                do {
                    try self.saveImage(profile.avatar)
                } catch let error {
                    DispatchQueue.main.async {
                        completion(error)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }
        
    }
    

    
    func saveImage(_ image: UIImage) throws {
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { throw
            DataImageError.dataError
        }
        
        do {
            try imageData.write(to: archiveURL, options: .noFileProtection)
        } catch let error {
            throw error
        }
    }
    
    
}


enum DataImageError: Error {
    case dataError
}
