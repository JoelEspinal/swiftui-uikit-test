//
//  Contact.swift
//  Contact List
//
//  Created by Joel Espinal on 13/6/26.
//

import Foundation


struct Contact: Equatable {
    
    var id: UUID?
    var name: String
    var lastName: String
    var phoneNumber: String
    var randomImageUrl: String?
    
    init(id: UUID, name: String, lastName: String, phoneNumber: String, randomImageUrl: String) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.randomImageUrl = randomImageUrl
    }
    
}
