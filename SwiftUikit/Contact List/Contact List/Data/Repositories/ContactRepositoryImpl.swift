//
//  Repositories.swift
//  Contact List
//
//  Created by Joel Espinal on 13/6/26.
//

import Foundation
import Observation
import CoreData

@MainActor
class ContactRepositoryImpl: ContactRepository {
    
    func getContact(byUUID uuid: UUID) -> Contact? {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<ContactMO> = ContactMO.fetchRequest()
        
        // Exact match filter
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        // Performance Optimization: Tell Core Data to stop looking after it finds the first match
        fetchRequest.fetchLimit = 1
        do {
            let results = try context.fetch(fetchRequest)

            var res: [ContactDTO] = results.compactMap(ContactDTO.fromContactModel)
            return res.first?.toEntity()
            
//            return results.map{$0.Contact} //.first // Returns the ContactMO or nil if not found
        } catch {
            print("Failed to look up contact: \(error)")
            return nil
        }
    }
    
    
    func save(contact: Contact) -> Contact? {
        let context = CoreDataManager.shared.context
        
        // 1. Create a new Core Data object instance
        let newContact = ContactMO(context: context)
        newContact.id = contact.id ?? UUID()
        newContact.name = contact.name
        newContact.lastName = contact.lastName
        newContact.phone = contact.phoneNumber
        newContact.imageUrl = contact.randomImageUrl
        
        // 2. Save it to disk
        CoreDataManager.shared.saveContext()
        
        return ContactDTO.fromContactModel(contact: newContact).toEntity()
        
//        // 3. Notify observers (e.g. ContactTableViewController) that data changed
//        NotificationCenter.default.post(name: .contactSaved, object: nil)

    }
}
