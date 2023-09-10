//
//  SHLocationsViewController.swift
//  TVShowApp
//
//  Created by Sergei on 26.08.2023.
//

import UIKit

/// Controller to show and search for locations
final class SHLocationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        
        addSearchButton()
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
}
