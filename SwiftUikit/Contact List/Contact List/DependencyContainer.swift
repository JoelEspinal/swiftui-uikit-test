//
//  DependencyContainer.swift
//  Contact List
//
//  Created by Joel Espinal
//

import Foundation

@MainActor
final class DependencyContainer {

    static let shared = DependencyContainer()

    // MARK: - Data layer

    private lazy var contactRepository: ContactRepository = ContactRepositoryImpl()

    private init() {}

    // MARK: - Domain layer

    private func makeGetContactUseCase() -> GetContactUseCase {
        GetContactUseCase(repository: contactRepository)
    }

    private func makeSaveContactUseCase() -> SaveContactUseCase {
        SaveContactUseCase(repository: contactRepository)
    }

    // MARK: - Presentation layer

    func makeContactViewModel() -> ContactViewModel {
        ContactViewModel(
            getContactUseCase: makeGetContactUseCase(),
            saveContactUseCase: makeSaveContactUseCase()
        )
    }
}
