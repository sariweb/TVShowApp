//
//  SHCharacterInfoCollectionViewCellViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 04.09.2023.
//

import UIKit

final class SHCharacterInfoCollectionViewCellViewModel {
    public let value: String
    public let title: String
    
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}
