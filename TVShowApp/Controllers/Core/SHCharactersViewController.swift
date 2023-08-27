//
//  SHCharactersViewController.swift
//  TVShowApp
//
//  Created by Sergei on 26.08.2023.
//

import UIKit

/// Controller to show and search for characters
final class SHCharactersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        SHService.shared.execute(.listCharacterRequests, expecting: SHGetCharactersResponse.self) { result in
            switch result {
                case .success(let model):
                    print(String(describing: model))
                case .failure(let error):
                    print(String(describing: error))
            }
        }
    }

}
