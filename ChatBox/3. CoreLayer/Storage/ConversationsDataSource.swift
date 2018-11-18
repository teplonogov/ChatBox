//
//  ConversationsDataSource.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 19/11/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import Foundation
import CoreData

class ConversationsDataSource: NSObject {
    weak var delegate: DataSourceDelegate?
    var fetchedResultsController: NSFetchedResultsController<Conversation>
    
    init(delegate: DataSourceDelegate, fetchRequest: NSFetchRequest<Conversation>, context: NSManagedObjectContext) {
        self.delegate = delegate
        fetchedResultsController = NSFetchedResultsController<Conversation>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        performFetch()
        fetchedResultsController.fetchedObjects?.forEach({ $0.isOnline = false })
    }
    
    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fetch -- ConversationsDataSource: \(error.localizedDescription)")
        }
    }
}



extension ConversationsDataSource: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        DispatchQueue.main.async {
            switch type {
            case .delete:
                if let indexPath = indexPath {
                    self.delegate?.deleteRows(at: [indexPath], with: .automatic)
                }
            case .insert:
                if let newIndexPath = newIndexPath {
                    self.delegate?.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .update:
                if let indexPath = indexPath {
                    self.delegate?.reloadRows(at: [indexPath], with: .automatic)
                }
            case .move:
                if let indexPath = indexPath {
                    self.delegate?.deleteRows(at: [indexPath], with: .automatic)
                }
                
                if let newIndexPath = newIndexPath {
                    self.delegate?.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.delegate?.beginUpdates()
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.delegate?.endUpdates()
        }
    }
    
}
