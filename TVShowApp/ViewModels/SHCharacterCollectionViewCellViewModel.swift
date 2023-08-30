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
        // TODO: Abstract to image manager
        guard let url = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        
        task.resume()
    }
}

