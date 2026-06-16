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
            
            let res: [ContactDTO] = results.compactMap(ContactDTO.fromContactModel)
            return res.first?.toEntity()
        } catch {
            print("Failed to look up contact: \(error)")
            return nil
        }
    }
    
    
    func save(contact: Contact) -> Contact? {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<ContactMO> = ContactMO.fetchRequest()
        var updateContact: ContactMO
        
        if contact.id != nil && contact.id != UUID.zero {
            fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [contact.id!])
            fetchRequest.fetchLimit = 1
            
            
            do {
                let results = try context.fetch(fetchRequest)
                if let existingContact = results.first {
                    // Found! Update the existing record
                    existingContact.name = contact.name
                    existingContact.lastName = contact.lastName
                    existingContact.phone = contact.phoneNumber
                    existingContact.imageUrl = contact.randomImageUrl
                    updateContact = existingContact
                } else {
                    // Create a new Contact
                    let newContact = ContactMO(context: context)
                    newContact.id = contact.id ?? UUID()
                    newContact.name = contact.name
                    newContact.lastName = contact.lastName
                    newContact.phone = contact.phoneNumber
                    newContact.imageUrl = contact.randomImageUrl
                    updateContact = newContact
                }
                
                try context.save()
                return ContactDTO.fromContactModel(contact: updateContact).toEntity()
            } catch {
                print("Failed to save or update: \(error)")
                return nil
            }
        }
        return nil
    }
}
