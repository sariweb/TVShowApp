//
//  SHCharacterDetailViewController.swift
//  TVShowApp
//
//  Created by Sergei on 31.08.2023.
//

import UIKit

/// Controller to show info about a single character
final class SHCharacterDetailViewController: UIViewController {
    private let viewModel: SHCharacterDetailViewViewModel
    
    init(viewModel: SHCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        view.backgroundColor = .systemBackground
    }

}
