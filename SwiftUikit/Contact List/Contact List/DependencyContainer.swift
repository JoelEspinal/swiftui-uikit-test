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

    private init() {}
    
    // MARK: - Service layer
    
    private lazy var randomImageService: RandomImageService = RandomImageService()
    
    // MARK: - Data layer

    private lazy var contactRepository: ContactRepository = ContactRepositoryImpl()

    private lazy var randomImageRepository: RandomImageRepository = RandomImageRepositoryImpl(imageService: randomImageService)

    private lazy var ContactViewModel: ContactViewModel = makeContactViewModel()

    // MARK: - Domain layer

    private func makeGetContactUseCase() -> GetContactUseCase {
        GetContactUseCase(repository: contactRepository)
    }

    private func makeSaveContactUseCase() -> SaveContactUseCase {
        SaveContactUseCase(repository: contactRepository)
    }
    
    private func makeGetRandomImageUseCase() -> GetRandomImageUseCase {
      GetRandomImageUseCase(repository: randomImageRepository)
    }

    // MARK: - Presentation layer

    func makeContactViewModel() -> ContactViewModel {
        Contact_List.ContactViewModel(
            getContactUseCase: makeGetContactUseCase(),
            saveContactUseCase: makeSaveContactUseCase(),
            getRandomImageUseCase: makeGetRandomImageUseCase()
        )
    }
}
