//
//  SHCharacterInfoCollectionViewCell.swift
//  TVShowApp
//
//  Created by Sergei on 04.09.2023.
//

import UIKit

final class SHCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "SHCharacterInfoCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .tertiarySystemBackground
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: SHCharacterInfoCollectionViewCellViewModel) {
        
    }
}
