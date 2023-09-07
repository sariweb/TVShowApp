//
//  SHEpisodeDetailViewController.swift
//  TVShowApp
//
//  Created by Sergei on 07.09.2023.
//

import UIKit

/// Controller to show info about a single episode
final class SHEpisodeDetailViewController: UIViewController {
    let url: URL?
    
    // MARK: - Init
    
    init(url: URL?) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        title = "Episode"
    }
}
