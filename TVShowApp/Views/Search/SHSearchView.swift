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
    
    // MARK: - Subviews
    
    private let searchInputView = SHSearchInputView()
    private let noResultsView = SHNoSearchResultsView()
    private let resultsView = SHSearchResultsView()
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: SHSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultsView, noResultsView, searchInputView)
        addConstraints()
        
        searchInputView.configure(with: .init(type: viewModel.config.type))
        searchInputView.delegate = self
        
        setupHandlers(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func setupHandlers(viewModel: SHSearchViewViewModel) {
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultsHandler { [weak self] results in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = true
                self?.resultsView.configure(with: results)
                self?.resultsView.isHidden = false
            }
        }
        
        viewModel.registerNoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // Search input view
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            // Results view
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            // No results view
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
    
    func shSearchInputView(_ inputView: SHSearchInputView, textDidChange searchText: String) {
        viewModel.set(query: searchText)
    }
    
    func shSearchInputView(_ inputView: SHSearchInputView, didSelect option: SearchOption) {
        delegate?.shSearchView(self, didSelect: option)
    }

    func shSearchInputViewDidTapSearchButton(_ inputView: SHSearchInputView) {
        viewModel.executeSearch()
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
