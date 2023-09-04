//
//  SHCharacterDetailView.swift
//  TVShowApp
//
//  Created by Sergei on 31.08.2023.
//

import UIKit

/// View for single character info
final class SHCharacterDetailView: UIView {
    public var collectionView: UICollectionView?
    
    private let viewModel: SHCharacterDetailViewViewModel
    
    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    init(frame: CGRect, viewModel: SHCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        guard let collectionView else { return }
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
       
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(
            SHCharacterPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: SHCharacterPhotoCollectionViewCell.identifier)
        view.register(
            SHCharacterInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: SHCharacterInfoCollectionViewCell.identifier)
        view.register(
            SHCharacterEpisodeCollectionViewCell.self,
            forCellWithReuseIdentifier: SHCharacterEpisodeCollectionViewCell.identifier)
        
        
        return view
    }
    
    private func createSection(for index: Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        
        switch sectionTypes[index] {
            case .photo:
                return viewModel.createPhotoSectionLayout()
            case .infornation:
                return viewModel.createInfoSectionLayout()
            case .episodes:
                return viewModel.createEpisodeSectionLayout()
        }
    }
}
