//
//  ZeroUUID.swift
//  Contact List
//
//  Created by Joel Espinal on 15/6/26.
//

import Foundation

extension UUID {
    /// Returns a nil/empty UUID containing all zeros.
    static var zero: UUID {
        UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
    }
}

// Usage
let id = UUID.zero
