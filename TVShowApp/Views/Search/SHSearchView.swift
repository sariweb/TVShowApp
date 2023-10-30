//
//  SHSearchView.swift
//  TVShowApp
//
//  Created by Sergei on 26.10.2023.
//

import UIKit

protocol SHSearchViewDelegate: AnyObject {
    func shSearchView(_ inputView: SHSearchView, didSelect option: SearchOption)
}

final class SHSearchView: UIView {
    weak var delegate: SHSearchViewDelegate?
    
    private let viewModel: SHSearchViewViewModel
    
    private let searchInputView = SHSearchInputView()
    private let noResultsView = SHNoSearchResultsView()
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: SHSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView, searchInputView)
        addConstraints()
        
        searchInputView.configure(with: .init(type: viewModel.config.type))
        searchInputView.delegate = self
        
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    // MARK: - Public
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
}

// MARK: - SHSearchInputViewDelegate

extension SHSearchView: SHSearchInputViewDelegate {
    func shSearchInputView(_ inputView: SHSearchInputView, didSelect option: SearchOption) {
        delegate?.shSearchView(self, didSelect: option)
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
