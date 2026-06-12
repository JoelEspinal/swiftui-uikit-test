//
//  CreateContactViewModel.swift
//  Contact List
//
//  Created by Joel Espinal on 12/6/26.
//


import Foundation
import Observation

extension Notification.Name {
    static let contactSaved = Notification.Name("ContactSaved")
}
import CoreData

@MainActor
@Observable
class ContactViewModel {
    
     var name: String = ""
     var lastName: String = ""
     var phoneNumber: String = ""
     var randomImageUrl: String = ""
    
    

    func save(name: String, lastName: String, phone: String, imageUrl: String) -> Void {
        let context = CoreDataManager.shared.context
        
        // 1. Create a new Core Data object instance
        let newContact = ContactMO(context: context)
        newContact.id = UUID()
        newContact.name = name
        newContact.lastName = lastName
        newContact.phone = phone
        newContact.imageUrl = imageUrl // From your API phase
        
        // 2. Save it to disk
        CoreDataManager.shared.saveContext()
        
        // 3. Notify observers (e.g. ContactTableViewController) that data changed
        NotificationCenter.default.post(name: .contactSaved, object: nil)
        
    }
    
    func getContact(byUUID uuid: UUID) -> ContactMO? {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<ContactMO> = ContactMO.fetchRequest()
        
        // Exact match filter
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        // Performance Optimization: Tell Core Data to stop looking after it finds the first match
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first // Returns the ContactMO or nil if not found
        } catch {
            print("Failed to look up contact: \(error)")
            return nil
        }
    }
}
