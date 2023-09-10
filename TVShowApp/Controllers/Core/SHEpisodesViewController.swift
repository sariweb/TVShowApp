//
//  SHEpisodesViewController.swift
//  TVShowApp
//
//  Created by Sergei on 26.08.2023.
//

import UIKit

/// Controller to show and search for episodes
final class SHEpisodesViewController: UIViewController {

    private let episodeListView = SHEpisodeListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        
        setupView()
        addSearchButton()
    }
    
    private func setupView() {
        episodeListView.delegate = self
        view.addSubview(episodeListView)
        
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            episodeListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
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

extension SHEpisodesViewController: SHEpisodeListViewDelegate {
    func shEpisodeListView(_ episodeListView: SHEpisodeListView, didSelectEpisode episode: SHEpisode) {
        let detailVC = SHEpisodeDetailViewController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}
