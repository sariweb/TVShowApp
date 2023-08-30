//
//  SHCharacterStatus.swift
//  TVShowApp
//
//  Created by Sergei on 27.08.2023.
//

import Foundation

// MARK: - SHCharacterStatus
enum SHCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
            case .alive, .dead:
                return rawValue
            case .unknown:
                return "Unknown"
        }
    }
}
