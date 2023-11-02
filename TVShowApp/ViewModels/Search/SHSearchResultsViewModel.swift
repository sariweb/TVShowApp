//
//  SHSearchResultsViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 02.11.2023.
//

import Foundation

enum SHSearchResultsViewModel {
    case characters([SHCharacterCollectionViewCellViewModel])
    case episodes([SHCharacterEpisodeCollectionViewCellViewModel])
    case locations([SHLocationTableViewCellViewModel])
}
