//
//  FetchContactUseCase.swift
//  Contact List
//
//  Created by Joel Espinal on 13/6/26.
//

import Foundation

@MainActor
struct GetContactUseCase {
    private let repository: ContactRepository
    
    init(repository: ContactRepository) {
        self.repository = repository
    }
    
    func execute(id: UUID) async throws -> Contact? {
        repository.getContact(byUUID: id)
    }
}
