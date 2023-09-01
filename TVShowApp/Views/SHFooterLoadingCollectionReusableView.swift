//
//  SHFooterLoadingCollectionReusableView.swift
//  TVShowApp
//
//  Created by Sergei on 01.09.2023.
//

import UIKit

final class SHFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "SHFooterLoadingCollectionReusableView"
    
    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(spinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
//
//            collectionView.topAnchor.constraint(equalTo: topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    public func startAnimating() {
        spinner.startAnimating()
    }
}
