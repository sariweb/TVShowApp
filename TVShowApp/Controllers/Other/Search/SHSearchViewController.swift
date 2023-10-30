//
//  SHSearchViewController.swift
//  TVShowApp
//
//  Created by Sergei on 09.09.2023.
//

import UIKit

/// Configurable controller to search
final class SHSearchViewController: UIViewController {
    
    /// Configuration for search
    struct Config {
        enum `Type`{
            case character  // name | status | gender
            case episode    // name
            case location   // name | type
            
            var title: String {
                switch self {
                    case .character:
                        return "Search Characters"
                    case .episode:
                        return "Search Episodes"
                    case .location:
                        return "Search Locations"
                }
            }
        }
        
        let type: `Type`
    }
    
    private let searchView: SHSearchView
    private let viewModel: SHSearchViewViewModel
    
    // MARK: - Init
    
    init(config: Config) {
        let viewModel = SHSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = SHSearchView(frame: .zero, viewModel: viewModel)
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        searchView.delegate = self
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapExecuteSearch))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.presentKeyboard()
    }
    
    // MARK: - Private
    
    @objc private func didTapExecuteSearch() {
        viewModel.executeSearch()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: - SHSearchViewDelegate

extension SHSearchViewController: SHSearchViewDelegate {
    func shSearchView(_ inputView: SHSearchView, didSelect option: SearchOption) {
        let vc = SHSearchOptionPickerViewController(option: option) { [weak self] selection in
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated: true)
    }
}
