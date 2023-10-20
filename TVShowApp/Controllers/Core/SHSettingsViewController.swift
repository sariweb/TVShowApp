//
//  SHSettingsViewController.swift
//  TVShowApp
//
//  Created by Sergei on 26.08.2023.
//

import SafariServices
import StoreKit
import SwiftUI
import UIKit

/// Controller to show various app options and settings
final class SHSettingsViewController: UIViewController {
    
    private var settingsSwiftUIController: UIHostingController<SHSettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()
    }

    private func addSwiftUIController() {
        let settingsSwiftUIController = UIHostingController(
            rootView: SHSettingsView(
                viewModel: SHSettingsViewViewModel(
                    cellViewModels: SHSettingsOption.allCases.compactMap {
                        return SHSettingsCellViewModel(type: $0) { [weak self] option in
                            guard let self else { return }
                            self.handleTap(option: option)
                        }
                    }
                )))
        
        addChild(settingsSwiftUIController)
        settingsSwiftUIController.didMove(toParent: self)
        view.addSubview(settingsSwiftUIController.view)
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            settingsSwiftUIController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
        self.settingsSwiftUIController = settingsSwiftUIController
    }
    
    private func handleTap(option: SHSettingsOption) {
        guard Thread.current.isMainThread else { return }
        
        if let url = option.targetUrl {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else if option == .rateApp {
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}
