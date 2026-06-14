//
//  ContactExtensions.swift
//  Contact List
//
//  Created by Joel Espinal on 13/6/26.
//


import CoreData

extension ContactDTO {
    func toDto() -> ContactDTO {
        var toDTO: ContactDTO {
            return ContactDTO(id: self.id ?? UUID(), name: self.name, lastName: self.lastName, phoneNumber: self.phoneNumber, imageUrl: self.imageUrl)
        }
        
        return toDTO
    }
    
    func toEntity() -> Contact {
        var toEntity: Contact {
            return Contact(id: self.id ?? UUID(), name: self.name, lastName: self.lastName, phoneNumber: self.phoneNumber, randomImageUrl: self.imageUrl)
        }
        
        return toEntity
    }
}
