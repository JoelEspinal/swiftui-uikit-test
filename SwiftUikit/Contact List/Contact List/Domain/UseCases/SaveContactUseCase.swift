//
//  SaveContactUseCase.swift
//  Contact List
//
//  Created by Joel Espinal on 13/6/26.
//

import Foundation

@MainActor
struct SaveContactUseCase {
    private let repository: ContactRepository
    
    init(repository: ContactRepository) {
        self.repository = repository
    }
    
    func execute(contact: Contact) async throws -> Contact? {
        repository.save(contact: contact)
    }
}
