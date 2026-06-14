//
//  ContactRepository.swift
//  Contact List
//
//  Created by Joel Espinal on 13/6/26.
//

import Foundation

@MainActor
protocol ContactRepository {

    func save(contact: Contact) -> Contact?
    func getContact(byUUID uuid: UUID) -> Contact?

}
