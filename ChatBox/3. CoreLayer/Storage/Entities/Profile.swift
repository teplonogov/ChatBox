//
//  Profile.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 06/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import CoreData

extension Profile {

    static func getRequest(model: NSManagedObjectModel) -> NSFetchRequest<Profile>? {
        let template = "FetchProfile"
        guard let request = model.fetchRequestTemplate(forName: template) as? NSFetchRequest<Profile> else {
            assert(false, "No template with typename \(template)")
            return nil }
        return request
    }

    static func insertProfile(in context: NSManagedObjectContext) -> Profile? {
        guard let profile = NSEntityDescription.insertNewObject(forEntityName: "Profile",
                                                                into: context) as? Profile else {
            return nil
        }
        profile.currentUser = User.insertUser(withID: UIDevice.current.name, in: context)
        profile.name = UIDevice.current.name
        profile.avatarImage = UIImage(named: "placeholder-user")!.jpegData(compressionQuality: 1.0)
        profile.descriptionProfile = ""
        return profile
    }

    static func getProfile(in context: NSManagedObjectContext, completion: @escaping (Profile?) -> Void) {
        context.perform {
            guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
                return
            }
            guard let request = Profile.getRequest(model: model) else { return }
            var profile: Profile?
            do {
                let results = try context.fetch(request)
                assert(results.count < 2, "profiles more than one")
                if !results.isEmpty {
                    profile = results.first!
                } else {
                    profile = Profile.insertProfile(in: context)
                }
                completion(profile)
            } catch {
                print("Failed to fetch profile: \(error)")
                completion(nil)
            }
        }
    }

}
