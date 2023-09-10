//
//  SHEpisodeDetailViewController.swift
//  TVShowApp
//
//  Created by Sergei on 07.09.2023.
//

import UIKit

/// Controller to show info about a single episode
final class SHEpisodeDetailViewController: UIViewController {
    private let viewModel: SHEpisodeDetailViewViewModel
    private let detailView: SHEpisodeDetailView
    
    // MARK: - Init
    
    init(url: URL?) {
        self.viewModel = SHEpisodeDetailViewViewModel(endpointUrl: url)
        self.detailView = SHEpisodeDetailView(frame: .zero)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episode"
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        addConstraints()
        
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    }
    
    @objc private func didTapShare() {
        // share episode info
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
    }
}

// MARK: - Delegate

extension SHEpisodeDetailViewController: SHEpisodeDetailViewViewModelDelegate {
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
}
