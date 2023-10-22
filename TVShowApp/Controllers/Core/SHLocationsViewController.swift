//
//  SHLocationsViewController.swift
//  TVShowApp
//
//  Created by Sergei on 26.08.2023.
//

import UIKit

/// Controller to show and search for locations
final class SHLocationsViewController: UIViewController {
    private let primaryView = SHLocationView()
    private let viewModel = SHLocationViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        
        view.addSubview(primaryView)
        primaryView.delegate = self
        addConstraints()
        addSearchButton()
        
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }
            
    @objc private func didTapSearch() {
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            primaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension SHLocationsViewController: SHLocationViewViewModelDelegate {
    func didLoadInitialLocations() {
        primaryView.configure(with: viewModel)
    }
}

extension SHLocationsViewController: SHLocationViewDelegate {
    func shLocationView(_ locationView: SHLocationView, didSelect location: SHLocation) {
        let detailVC = SHLocationDetailViewController(location: location)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
