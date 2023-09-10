//
//  SHSearchViewController.swift
//  TVShowApp
//
//  Created by Sergei on 09.09.2023.
//

import UIKit

/// Configurable controller to search
final class SHSearchViewController: UIViewController {

    struct Config {
        enum `Type`{
            case character
            case episode
            case location
        }
        
        let type: `Type`
    }
    
    private let config: Config
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
    }


}
