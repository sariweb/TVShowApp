//
//  SHEndpoint.swift
//  TVShowApp
//
//  Created by Sergei on 27.08.2023.
//

import Foundation

/// Represents unique API endpoint
@frozen enum SHEndpoint: String, CaseIterable, Hashable {
    /// Endpoint to get character info
    case character
    /// Endpoint to get  location info
    case location
    /// Endpoint to get episode info
    case episode
}
