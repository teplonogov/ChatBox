//
//  User.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 11/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import CoreData

extension User {

    static func insertUser(withID: String, in context: NSManagedObjectContext) -> User {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else {
            fatalError("Can't insert User")
        }
        user.userID = withID
        return user
    }

    static func findOrInsertUser(withID: String, in context: NSManagedObjectContext) -> User? {
        let fetchRequests = FetchRequests()
        let request = fetchRequests.fetchUser(withID: withID)
        do {
            let users = try context.fetch(request)
            assert(users.count < 2, "Users with id \(withID) more than 1")
            if !users.isEmpty {
                return users.first!
            } else {
                return User.insertUser(withID: withID, in: context)
            }
        } catch {
            assertionFailure("Can't fetch users. Check correction of fetch")
            return nil
        }
    }

}
