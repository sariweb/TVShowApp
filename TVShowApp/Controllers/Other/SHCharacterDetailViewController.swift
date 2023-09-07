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
    private let detailView: SHCharacterDetailView
    
    // MARK: - Init
    
    init(viewModel: SHCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = SHCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        addConstraints()
    }

    @objc private func didTapShare() {
        // share char info
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        
    }
}


// MARK: - CollectionView

extension SHCharacterDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        
        switch sectionType {
            case .photo:
                return 1
            case .infornation(viewModels: let viewModels):
                return viewModels.count
            case .episodes(viewModels: let viewModels):
                return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let sectionType = viewModel.sections[indexPath.section]
        
        switch sectionType {
            case .photo(viewModel: let viewModel):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SHCharacterPhotoCollectionViewCell.identifier,
                    for: indexPath) as? SHCharacterPhotoCollectionViewCell else {
                    fatalError("Unsupported")
                    
                }
                cell.configure(with: viewModel)
                return cell
            case .infornation(viewModels: let viewModels):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SHCharacterInfoCollectionViewCell.identifier,
                    for: indexPath) as? SHCharacterInfoCollectionViewCell else {
                    fatalError("Unsupported")
                    
                }
                cell.configure(with: viewModels[indexPath.row])
                return cell
            case .episodes(viewModels: let viewModels):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SHCharacterEpisodeCollectionViewCell.identifier,
                    for: indexPath) as? SHCharacterEpisodeCollectionViewCell else {
                    fatalError("Unsupported")
                    
                }
                cell.configure(with: viewModels[indexPath.row])
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = viewModel.sections[indexPath.section]
        
        switch sectionType {
            case .photo,
                .infornation:
                break
            case .episodes:
                let episodes = self.viewModel.episodes
                let selection = episodes[indexPath.row]
                let vc = SHEpisodeDetailViewController(url: URL(string: selection))
                navigationController?.pushViewController(vc, animated: true)
        }
    }
}
