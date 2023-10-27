//
//  SHSearchView.swift
//  TVShowApp
//
//  Created by Sergei on 26.10.2023.
//

import UIKit

final class SHSearchView: UIView {
    private let viewModel: SHSearchViewViewModel
    
    private let noResultsView = SHNoSearchResultsView()
    
    init(frame: CGRect, viewModel: SHSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            noResultsView.topAnchor.constraint(equalTo: topAnchor),
            noResultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            noResultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            noResultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

//extension SHSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//    }
//}
