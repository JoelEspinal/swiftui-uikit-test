//
//  ContactDTO.swift
//  Contact List
//
//  Created by Joel Espinal on 13/6/26.
//

import Foundation
import CoreData

struct ContactDTO: Identifiable, Codable{
    let id: UUID?
    let name: String
    let lastName: String
    let phoneNumber: String
    let imageUrl: String
    
    static func fromContactModel(contact: ContactMO) -> ContactDTO {
        return ContactDTO(id: contact.id, name: contact.name ?? "", lastName: contact.lastName ?? "" , phoneNumber: contact.phone ?? "", imageUrl: contact.imageUrl ?? "")
    }
}
