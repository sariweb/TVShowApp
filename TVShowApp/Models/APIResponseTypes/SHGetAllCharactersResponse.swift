//
//  SHGetAllCharactersResponse.swift
//  TVShowApp
//
//  Created by Sergei on 27.08.2023.
//

import Foundation

struct SHGetAllCharactersResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [SHCharacter]
}
