//
//  SHLocationTableViewCellViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 22.10.2023.
//

import Foundation

struct SHLocationTableViewCellViewModel {
    private let location: SHLocation
    
    init(location: SHLocation) {
        self.location = location
    }
    
    public var name: String {
        return location.name
    }
    
    public var type: String {
        return "Type: " + location.type
    }
    
    public var dimension: String {
        return location.dimension
    }
}

// MARK: - Hashable & Equatable

extension SHLocationTableViewCellViewModel: Hashable, Equatable {
    static func == (lhs: SHLocationTableViewCellViewModel,
                    rhs: SHLocationTableViewCellViewModel
    ) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location.id)
    }
}
