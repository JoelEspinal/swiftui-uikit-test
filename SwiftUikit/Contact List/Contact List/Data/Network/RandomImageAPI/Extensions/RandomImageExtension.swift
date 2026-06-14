//
//  RandomImage.swift
//  Contact List
//
//  Created by Joel Espinal on 14/6/26.
//

extension RandomImageDTO {
    func toEntity() -> RandomImage {
        return RandomImage(
            url: url
        )
    }
}
