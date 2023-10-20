//
//  SHSettingsCellViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 17.10.2023.
//

import UIKit

struct SHSettingsCellViewModel: Identifiable {
    let id = UUID()
    
    public let type: SHSettingsOption
    public var onTapHandler: (SHSettingsOption) -> Void
    
    // MARK: - Init
    
    init(type: SHSettingsOption, onTapHandler: @escaping (SHSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    // MARK: - Public
    
    public var image: UIImage? {
        return type.iconImage
    }
    
    public var title: String {
        return type.displayTitle
    }
    
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
}
