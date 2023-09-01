//
//  SHCharacterListView.swift
//  TVShowApp
//
//  Created by Sergei on 27.08.2023.
//

import UIKit

protocol SHCharacterListViewDelegate: AnyObject {
    func shCharacterListView(
        _ characterListView: SHCharacterListView,
        didSelectCharacter character: SHCharacter
    )
}

/// View that handles showing list of characters, loader, etc.
final class SHCharacterListView: UIView {
    
    private let viewModel = SHCharacterListViewViewModel()
    
    public weak var delegate: SHCharacterListViewDelegate?
    
    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(
            SHCharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: SHCharacterCollectionViewCell.identifier)
        view.register(
            SHFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: SHFooterLoadingCollectionReusableView.identifier)
        
        return view
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        addConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchCharacters()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
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

    private func setupCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

extension SHCharacterListView: SHCharacterListViewViewModelDelegate {
    func didSelectCharacter(_ character: SHCharacter) {
        delegate?.shCharacterListView(self, didSelectCharacter: character)
    }
    
    func didLoadInitialCharacters() {
        collectionView.reloadData()
        spinner.stopAnimating()
        collectionView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
}
