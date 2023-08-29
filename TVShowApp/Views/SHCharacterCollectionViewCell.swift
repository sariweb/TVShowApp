//
//  SHCharacterCollectionViewCell.swift
//  TVShowApp
//
//  Created by Sergei on 29.08.2023.
//

import UIKit

/// Singe cell for a character
final class SHCharacterCollectionViewCell: UICollectionViewCell {
    static let identifier = "SHCharacterCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(imageView, nameLabel, statusLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
        statusLabel.heightAnchor.constraint(equalToConstant: 40),
        nameLabel.heightAnchor.constraint(equalToConstant: 40),
        
        statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
        statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
        nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -3),
        
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3),

        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        statusLabel.text = nil
    }
    
    public func configure(with viewModel: SHCharacterCollectionViewCellViewModel) {
        nameLabel.text = viewModel.name
        statusLabel.text = viewModel.statusText
        viewModel.fetchImage { [weak self] result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.imageView.image = UIImage(data: data)
                    }
                case .failure(let error):
                    print(String(describing: error))
                    break
            }
        }
    }
}
