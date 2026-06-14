//
//  RandomImageServices.swift
//  Contact List
//
//  Created by Joel Espinal on 14/6/26.
//

import Foundation

class RandomImageService {
    
    func fetchCharacter() async throws -> RandomImageDTO {
        let randomImageUrl = "\(Constants.RANDOM_DOG_API)?limit=1"
            
        let (data, response) = try await URLSession.shared.data(from: URL(string: randomImageUrl)!)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.BadResponse
        }
        
        let decoder = JSONDecoder()
        let characterDTO = try decoder.decode(RandomImageDTO.self, from: data)
                
        return characterDTO
    }
}
