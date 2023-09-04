//
//  SHCharacterCollectionViewCellViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 29.08.2023.
//

import UIKit

final class SHCharacterCollectionViewCellViewModel {
    public let name: String
    private let status: SHCharacterStatus
    private let imageUrl: URL?
    
    // MARK: - Init
    
    init(name: String,
         status: SHCharacterStatus,
         imageUrl: URL?) {
        self.name = name
        self.status = status
        self.imageUrl = imageUrl
    }
    
    public var statusText: String {
        return "Status: \(status.text)"
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        SHImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
}

// MARK: - Hashable & Equatable

extension SHCharacterCollectionViewCellViewModel: Hashable, Equatable {
    static func == (lhs: SHCharacterCollectionViewCellViewModel, rhs: SHCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(statusText)
        hasher.combine(imageUrl)
    }
}
