//
//  SHCharacterDetailViewViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 31.08.2023.
//

import Foundation

final class SHCharacterDetailViewViewModel {
    private let character: SHCharacter
    
    init(character: SHCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
