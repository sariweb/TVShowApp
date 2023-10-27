//
//  SHSearchInputView.swift
//  TVShowApp
//
//  Created by Sergei on 26.10.2023.
//

import UIKit

final class SHSearchInputView: UIView {
    private var viewModel: SHSearchInputViewViewModel? {
        didSet {
            guard let viewModel, viewModel.hasDynamicOptions else { return }
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        
        return searchBar
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(searchBar)
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58),
        ])
    }
    
    private func createOptionSelectionViews(options: [SHSearchInputViewViewModel.DynamicOption]) {
        for option in options {
            print(option.rawValue)
        }
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: SHSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }
}
