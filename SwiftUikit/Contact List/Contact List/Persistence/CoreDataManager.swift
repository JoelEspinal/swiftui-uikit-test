//
//  CoreDataManager.swift
//  Contact List
//
//  Created by Joel Espinal on 12/6/26.
//

import Foundation
import CoreData

@objc class CoreDataManager: NSObject {
    // Shared singleton instance accessible by Objective-C
    @objc static let shared = CoreDataManager()
    
    private override init() { super.init() }
    
    // Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ContactModel")
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // Main context for reading/writing
    @objc var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Save function exposed to both languages
    @objc func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Error saving Core Data: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
