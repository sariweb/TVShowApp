//
//  SHCharacter.swift
//  TVShowApp
//
//  Created by Sergei on 26.08.2023.
//

import Foundation

// MARK: - SHCharacter
struct SHCharacter: Codable {
    let id: Int
    let name: String
    let status: SHCharacterStatus
    let species: String
    let type: String
    let gender: SHCharacterGender
    let origin: SHOrigin
    let location: SHOrigin
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
