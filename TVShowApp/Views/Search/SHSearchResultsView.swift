//
//  SHSearchResultsView.swift
//  TVShowApp
//
//  Created by Sergei on 03.11.2023.
//

import UIKit

/// Shows search results UI (table or collection as needed)
final class SHSearchResultsView: UIView {
    private var viewModel: SHSearchResultsViewModel? {
        didSet {
            processViewModel()
        }
    }
    
    private let tableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SHLocationTableViewCell.self,
                      forCellReuseIdentifier: SHLocationTableViewCell.identifier)
        view.isHidden = true
        
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        addSubviews(tableView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        tableView.backgroundColor = .systemBlue
    }
    
    private func processViewModel() {
        guard let viewModel else { return }
        
        switch viewModel {
            case .characters(let viewModels):
                setupCoolectionView()
            case .episodes(let viewModels):
                setupCoolectionView()
            case .locations(let viewModels):
                setupTableView()
        }
    }
    
    private func setupCoolectionView() {
        
    }
    
    private func setupTableView() {
        tableView.isHidden = false
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: SHSearchResultsViewModel) {
        self.viewModel = viewModel
    }
    
}

