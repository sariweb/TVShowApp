//
//  SHCharacterPhotoCollectionViewCellViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 04.09.2023.
//

import UIKit

final class SHCharacterPhotoCollectionViewCellViewModel {
    private let imageUrl: URL?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        SHImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
}
