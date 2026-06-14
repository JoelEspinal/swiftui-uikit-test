//
//  RandomImageRepository.swift
//  Contact List
//
//  Created by Joel Espinal on 14/6/26.
//

import Foundation

@MainActor
protocol RandomImageRepository {

    func fetchRandomImage() async throws -> RandomImage?
}
