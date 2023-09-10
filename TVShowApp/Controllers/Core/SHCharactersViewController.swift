//
//  SHCharactersViewController.swift
//  TVShowApp
//
//  Created by Sergei on 26.08.2023.
//

import UIKit

/// Controller to show and search for characters
final class SHCharactersViewController: UIViewController {

    private let characterListView = SHCharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        setupView()
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
        let vc = SHSearchViewController(config: SHSearchViewController.Config(type: .character))
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
            
    private func setupView() {
        characterListView.delegate = self
        view.addSubview(characterListView)
        
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

}

extension SHCharactersViewController: SHCharacterListViewDelegate {
    func shCharacterListView(_ characterListView: SHCharacterListView, didSelectCharacter character: SHCharacter) {
        let viewModel = SHCharacterDetailViewViewModel(character: character)
        let detailVC = SHCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
