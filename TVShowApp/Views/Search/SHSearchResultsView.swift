//
//  SHSearchResultsView.swift
//  TVShowApp
//
//  Created by Sergei on 03.11.2023.
//

import UIKit

protocol SHSearchResultsViewDelegate: AnyObject {
    func shSearchResultsView(_ resultsView: SHSearchResultsView, didTapLocationAt index: Int)
}

/// Shows search results UI (table or collection as needed)
final class SHSearchResultsView: UIView {
    weak var delegate: SHSearchResultsViewDelegate?
    
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
    
    private var locationCellViewModels: [SHLocationTableViewCellViewModel] = []
    
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
    }
    
    private func processViewModel() {
        guard let viewModel else { return }
        
        switch viewModel {
            case .characters(let viewModels):
                setupCoolectionView()
            case .episodes(let viewModels):
                setupCoolectionView()
            case .locations(let viewModels):
                setupTableView(viewModels: viewModels)
        }
    }
    
    private func setupCoolectionView() {
        
    }
    
    private func setupTableView(viewModels: [SHLocationTableViewCellViewModel]) {
        tableView.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        self.locationCellViewModels = viewModels
        tableView.reloadData()
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: SHSearchResultsViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SHSearchResultsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SHLocationTableViewCell.identifier, for: indexPath) as? SHLocationTableViewCell else { fatalError("Failed dequeue SHLocationTableViewCell") }
        let viewModel = locationCellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.shSearchResultsView(self, didTapLocationAt: indexPath.row)
    }
}
