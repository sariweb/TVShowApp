//
//  SHEpisodeInfoCollectionViewCell.swift
//  TVShowApp
//
//  Created by Sergei on 09.09.2023.
//

import UIKit

class SHEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "SHEpisodeInfoCollectionViewCell"
    
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
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.secondaryLabel.cgColor
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
    
    public func configure(with viewModel: SHEpisodeInfoCollectionViewCellViewModel) {
        
    }

}
