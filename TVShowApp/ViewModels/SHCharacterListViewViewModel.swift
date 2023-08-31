//
//  SHCharacterListViewViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 27.08.2023.
//

import UIKit

protocol SHCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didSelectCharacter(_ character: SHCharacter)
}

final class SHCharacterListViewViewModel: NSObject {
    weak var delegate: SHCharacterListViewViewModelDelegate?
    
    private var characters: [SHCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = SHCharacterCollectionViewCellViewModel(
                    name: character.name,
                    status: character.status,
                    imageUrl: URL(string: character.image)
                )
                cellViewModels.append(viewModel)
            }
        }
    }
    
    private var cellViewModels: [SHCharacterCollectionViewCellViewModel] = []
    
    func fetchCharacters() {
        SHService.shared.execute(
            .listCharacterRequests,
            expecting: SHGetCharactersResponse.self
        ) { [weak self] result in
            switch result {
                case .success(let responseModel):
                    let results = responseModel.results
                    self?.characters = results
                    DispatchQueue.main.async {
                        self?.delegate?.didLoadInitialCharacters()
                    }
                case .failure(let error):
                    print(String(describing: error))
            }
        }
        
    }
}

extension SHCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SHCharacterCollectionViewCell.identifier,
            for: indexPath) as? SHCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}
