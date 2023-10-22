//
//  SHGetEpisodesResponse.swift
//  TVShowApp
//
//  Created by Sergei on 09.09.2023.
//

import Foundation

struct SHGetAllEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [SHEpisode]
}
