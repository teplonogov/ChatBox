//
//  OperationDataManager..swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 21/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation


class OperationDataManager: GetSaveProfileProtocol {
    
    let fileDirectory: URL
    let archiveURL: URL
    let operationQueue = OperationQueue()
    
    init() {
        fileDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        archiveURL = fileDirectory.appendingPathComponent("user_profile").appendingPathExtension("plist")
    }
    
    func getProfile(completion: @escaping (UserProfile) -> ()) {
        let getOperation = GetUserProfile()
        getOperation.archiveURL = archiveURL
        getOperation.completionHandler = completion
        operationQueue.addOperation(getOperation)
    }
    
    func saveProfile(profile: UserProfile, nameChanged: Bool, descriptionChanged: Bool, avatarChanged: Bool, completion: @escaping (Error?) -> ()) {
        
        let saveOperation = SaveUserProfile(nameChanged: nameChanged, descriptionChanged: descriptionChanged, avatarChanged: avatarChanged)
        saveOperation.userProfile = profile
        saveOperation.archiveURL = archiveURL
        saveOperation.completionHandler = completion
        operationQueue.addOperation(saveOperation)
        
    }
    
    
    
}


class GetUserProfile: Operation {
    
    var profile: UserProfile!
    var archiveURL: URL!
    var completionHandler: ((UserProfile) -> ())!
    
    override func main() {
        sleep(1)
        
        let name = UserDefaults.standard.string(forKey: "user_name") ?? "No name"
        let description = UserDefaults.standard.string(forKey: "user_description") ?? ""
        let avatar: UIImage
        
        if let imageData = try? Data(contentsOf: archiveURL), UIImage(data: imageData) != nil {
            avatar = UIImage(data: imageData)!
        } else {
            avatar = UIImage(named: "placeholder-user")!
        }
        
        profile = UserProfile(name: name, description: description, avatar: avatar)
        OperationQueue.main.addOperation {
            self.completionHandler(self.profile)
            
        }
    }
}

class SaveUserProfile: Operation {
    var userProfile: UserProfile!

    var completionHandler: ((Error?) -> ())!
    var archiveURL: URL!
    
    let nameChanged: Bool
    let descriptionChanged: Bool
    let avatarChanged: Bool

    init(nameChanged: Bool, descriptionChanged: Bool, avatarChanged: Bool) {
        self.nameChanged = nameChanged
        self.descriptionChanged = descriptionChanged
        self.avatarChanged = avatarChanged
    }
    
    override func main() {
        sleep(1)
        
        if nameChanged {
            UserDefaults.standard.set(userProfile.name, forKey: "user_name")
        }
        
        if descriptionChanged {
            UserDefaults.standard.set(userProfile.description, forKey: "user_description")
        }
        
        if avatarChanged {
            guard let imageData = userProfile.avatar.jpegData(compressionQuality: 1.0) else {
                OperationQueue.main.addOperation {
                    self.completionHandler(DataImageError.dataError)
                }
                return
            }
            do {
                try imageData.write(to: archiveURL, options: .noFileProtection)
            } catch let error {
                self.completionHandler(error)
            }
        }
        OperationQueue.main.addOperation {
            self.completionHandler(nil)
        }
    }
}
