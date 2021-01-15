//
//  Persistance.swift
//  coffeTracker
//
//  Created by Kyryl Horbushko on 12/29/20.
//

import Foundation
import CoreData
import SwiftUI

struct PersistenceController {
    private enum CoreDataModelName: String {
        
        case main = "coffee"
    }
    
    @available(*, unavailable) private init () {}
    
    // MARK: - Core Data stack
    
    public static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: PersistenceController.CoreDataModelName.main.rawValue)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    public static var backgroundContext: StorableContext = {
        let context = persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.shouldDeleteInaccessibleFaults = true
        return context
    }()
    
    public static var mainContext: StorableContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    public static func saveContext() {
        let context = persistentContainer.viewContext
        saveProvidedContext(context)
    }
    
    public static func saveContext(_ context: NSManagedObjectContext) {
        saveProvidedContext(context)
    }
    
    public static func purgeAllData() {
        mainContext.performAndWait {
            let uniqueNames = persistentContainer.managedObjectModel.entities.compactMap({ $0.name })
            
            uniqueNames.forEach { (name) in
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try persistentContainer.viewContext.execute(batchDeleteRequest)
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            mainContext.reset()
        }
    }
    
    // MARK: - Clear
    
    public static func clearBackgroundContext() {
        backgroundContext.reset()
    }
    
    public static func clearContext(_ context: NSManagedObjectContext) {
        context.reset()
    }
    
    // MARK: - Private
    
    private static func saveProvidedContext(_ context: NSManagedObjectContext) {
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}

import Foundation
import CoreData

public typealias StorableContext = NSManagedObjectContext

@objc public protocol StorableObject where Self: NSManagedObject {
    
}

public extension StorableObject {
    
    static func create() -> Self {
        Self(context: PersistenceController.mainContext)
    }
        
    // MARK: - MainContext
    
    static func fetchInMainContext() -> [Self]? {
        let context = PersistenceController.mainContext
        return ManagedObjectManager.fetchIn(context, predicate: nil)
    }
    
    func deleteInMainContext() {
        let context = PersistenceController.mainContext
        ManagedObjectManager.removeIn(context, managedObjects: [self])
    }
    
    // MARK: - Background Context
    
    static func fetchInBackgroundContext() -> [Self]? {
        let context = PersistenceController.mainContext
        return ManagedObjectManager.fetchIn(context, predicate: nil)
    }
    
    func deleteInBackgroundContext() {
        let context = PersistenceController.mainContext
        ManagedObjectManager.removeIn(context, managedObjects: [self])
    }
    
    static func deleteAllInBackgroundContextAndCommit() {
        let context = PersistenceController.mainContext

        if let prevRecords = Self.fetchInBackgroundContext(),
           !prevRecords.isEmpty {
            ManagedObjectManager.removeIn(context, managedObjects: prevRecords)
            PersistenceController.saveContext(context)
        }
    }
}

import Foundation
import CoreData

final public class ManagedObjectManager {
    
    @available(*, unavailable) private init () {}
    
    // MARK: - Dedicated Context
    
    static public func removeIn(_ context: StorableContext, managedObjects: [NSManagedObject]) {
        context.performAndWait {
            for model in managedObjects {
                context.delete(model)
            }
        }
    }
    
    public static func fetchIn<T: NSManagedObject>(_ context: StorableContext, predicate: NSPredicate?) -> [T]? {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate
        return context.performAndWait {
            do {
                let objects = try context.fetch(fetchRequest)
                return objects
            } catch let error {
                assertionFailure(error.localizedDescription)
                return nil
            }
        }
    }
}

public extension NSManagedObjectContext {
    
    // MARK: - Improved Perform and Wait - sync and data
    
    func performAndWait<T>(_ block: () -> T) -> T {
        var result: T? = nil
        performAndWait {
            result = block()
        }
        return result!
    }
}
