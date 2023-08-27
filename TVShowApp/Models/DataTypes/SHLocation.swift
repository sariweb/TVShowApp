//
//  SHLocation.swift
//  TVShowApp
//
//  Created by Sergei on 26.08.2023.
//

import Foundation

// MARK: - SHLocation
struct SHLocation: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
