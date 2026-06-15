//
//  RandomImageRepositoryImpl.swift
//  Contact List
//
//  Created by Joel Espinal on 14/6/26.
//


import Foundation

@MainActor
class RandomImageRepositoryImpl: RandomImageRepository {
    private let imageService: RandomImageService
    
    init(imageService: RandomImageService) {
        self.imageService = imageService
    }
    
    func fetchRandomImage() async throws -> RandomImage? {
        let randomImage = try! await imageService.fetchRandomImage()
        let imageEntity = randomImage?.toEntity()
        return imageEntity
    }
}
