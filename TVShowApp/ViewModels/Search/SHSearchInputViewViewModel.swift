//
//  SHSearchInputViewViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 26.10.2023.
//

import Foundation

final class SHSearchInputViewViewModel {
    private let type: SHSearchViewController.Config.`Type`
    
    enum DynamicOption: String {
        case status = "Status"
        case genre = "Genre"
        case locationType = "Location Type"
        
        var choices: [String] {
            switch self {
                case .status:
                    return ["alive", "dead", "unknown"]
                case .genre:
                    return ["male", "female", "genderless", "unknown"]
                case .locationType:
                    return ["cluster", "planet", "microverse"]
            }
        }
    }
    
    // MARK: - Init
    
    init(type: SHSearchViewController.Config.`Type`    ) {
        self.type = type
    }
    
    
    // MARK: - Public
    
    public var hasDynamicOptions: Bool {
        switch type {
            case .character, .location:
                return true
            case .episode:
                return false
        }
    }
    
    public var options: [DynamicOption] {
        switch type {
            case .character:
                return [.status, .genre]
            case .episode:
                return []
            case .location:
                return [.locationType]
        }
    }
    
    public var searchPlaceholderText: String {
        switch type {
            case .character:
                return "Character Name"
            case .episode:
                return "Episode Title"
            case .location:
                return "Location Name"
        }
    }
}

typealias SearchOption = SHSearchInputViewViewModel.DynamicOption
