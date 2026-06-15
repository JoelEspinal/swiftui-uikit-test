//
//  RandomImage.swift
//  Contact List
//
//  Created by Joel Espinal on 14/6/26.
//

import Foundation

struct RandomImageDTO: Codable {
    let id: String
    let url: String
    let width, height: Int
}

typealias images = [RandomImage]

