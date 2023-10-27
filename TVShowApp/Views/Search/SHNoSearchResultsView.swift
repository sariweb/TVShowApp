//
//  SHNoSearchResultsView.swift
//  TVShowApp
//
//  Created by Sergei on 26.10.2023.
//

import UIKit

final class SHNoSearchResultsView: UIView {
    private let viewModel = SHNoSearchResultsViewViewModel()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        isHidden = true
        addSubviews(imageView, titleLabel)
        addConstraints()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 90),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
    }
    
    private func configure() {
        imageView.image = viewModel.image
        titleLabel.text = viewModel.title
    }
}
