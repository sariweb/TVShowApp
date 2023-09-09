//
//  SHEpisodeCollectionViewCell.swift
//  TVShowApp
//
//  Created by Sergei on 09.09.2023.
//

import UIKit

class SHEpisodeCollectionViewCell: UICollectionViewCell {
    static let identifier = "SHEpisodeCollectionViewCell"
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        addConstraints()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
        contentView.layer.shadowColor = UIColor.label.cgColor
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([

        ])
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupLayer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

    }

}
