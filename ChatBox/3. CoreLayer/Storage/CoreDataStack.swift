//
//  CoreDataStack.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 31/10/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataStack {
    func performSave(context: NSManagedObjectContext, completionHandler: ((Error?) -> Void)?)
    var mainContext: NSManagedObjectContext { get }
    var saveContext: NSManagedObjectContext { get }
}

class CoreDataStack: ICoreDataStack {

    static let shared = CoreDataStack()

    private init() {}

    private var storeURL: URL {
        let directoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = directoryURL.appendingPathComponent("CoreDataModel.sqlite")
        return url
    }

    private let managedObjectModelName = "CoreDataModel"

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.managedObjectModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeURL,
                                               options: nil)
        } catch {
            assert(false, "Error adding persistent store to coordinator: \(error)")
        }

        return coordinator
    }()

    lazy var saveContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        context.undoManager = nil
        return context
    }()

    lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = masterContext
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        context.undoManager = nil
        return context
    }()

    lazy var masterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        context.undoManager = nil
        return context
    }()

    func performSave(context: NSManagedObjectContext, completionHandler: ((Error?) -> Void)?) {
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    completionHandler?(error)
                }
                if let parentContext = context.parent {
                    self.performSave(context: parentContext, completionHandler: completionHandler)
                } else {
                    completionHandler?(nil)
                }
            } else {
                completionHandler?(nil)
            }
        }
    }

}
