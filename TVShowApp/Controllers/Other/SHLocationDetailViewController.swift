//
//  SHLocationDetailViewController.swift
//  TVShowApp
//
//  Created by Sergei on 22.10.2023.
//

import UIKit

class SHLocationDetailViewController: UIViewController {
    private let viewModel: SHLocationDetailViewViewModel
    private let detailView = SHLocationDetailView()
    
    // MARK: - Init
    
    init(location: SHLocation) {
        let url = URL(string: location.url)
        self.viewModel = SHLocationDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Location"
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        detailView.delegate = self
        viewModel.delegate = self
        viewModel.fetchLocationData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        addConstraints()
    }

    @objc private func didTapShare() {
        // share info
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

extension SHLocationDetailViewController: SHLocationDetailViewDelegate {
    func shLocationDetailView(
        _ detailView: SHLocationDetailView,
        didSelect character: SHCharacter
    ) {
        let vc = SHCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SHLocationDetailViewController: SHLocationDetailViewViewModelDelegate {
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
}
