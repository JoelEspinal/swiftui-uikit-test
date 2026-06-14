//
//  SaveContactUseCase.swift
//  Contact List
//
//  Created by Joel Espinal on 13/6/26.
//

import Foundation

@MainActor
struct GetRandomImageUseCase {
    private let repository: RandomImageRepository
    
    init(repository: RandomImageRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> RandomImage? {
        try! await repository.fetchRandomImage()
    }
}
