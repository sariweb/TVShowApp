//
//  SHCharacterInfoCollectionViewCellViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 04.09.2023.
//

import UIKit

final class SHCharacterInfoCollectionViewCellViewModel {
    public let value: String
    public let type: `Type`
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter
    }()
    
    public var title: String {
        type.displayTitle
    }
    
    public var displayValue: String {
        if value.isEmpty { return "None" }
        
        if let date = Self.dateFormatter.date(from: value) {
            return Self.shortDateFormatter.string(from: date)
        }
        return value
    }
    
    public var iconImage: UIImage? {
        type.iconImage
    }
    
    public var tintColor: UIColor {
        type.tintColor
    }
    
    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        
        var tintColor: UIColor {
            switch self {
                case .status:
                    return .systemRed
                case .gender:
                    return .systemOrange
                case .type:
                    return .systemYellow
                case .species:
                    return .systemGreen
                case .origin:
                    return .systemBlue
                case .created:
                    return .systemPurple
                case .location:
                    return .systemPink
                case .episodeCount:
                    return .systemMint
            }
        }
        
        var iconImage: UIImage? {
            switch self {
                case .status:
                    return UIImage(systemName: "bell")
                case .gender:
                    return UIImage(systemName: "bell")
                case .type:
                    return UIImage(systemName: "bell")
                case .species:
                    return UIImage(systemName: "bell")
                case .origin:
                    return UIImage(systemName: "bell")
                case .created:
                    return UIImage(systemName: "bell")
                case .location:
                    return UIImage(systemName: "bell")
                case .episodeCount:
                    return UIImage(systemName: "bell")
            }
        }
        
        var displayTitle: String {
            switch self {
                case .status,
                    .gender,
                    .type,
                    .species,
                    .origin,
                    .created,
                    .location:
                    return rawValue.uppercased()
                case .episodeCount:
                    return "EPISODE COUNT"
            }
        }
    }
    
    init(type: `Type`, value: String) {
        self.value = value
        self.type = type
    }
}
