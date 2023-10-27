//
//  SHGetAllLocationsResponse.swift
//  TVShowApp
//
//  Created by Sergei on 22.10.2023.
//

import Foundation

struct SHGetAllLocationsResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    
    let info: Info
    let results: [SHLocation]
}

