//
//  SHCharacterListViewViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 27.08.2023.
//

import UIKit


final class SHCharacterListViewViewModel: NSObject {
    
    func fetchCharacters() {
        SHService.shared.execute(.listCharacterRequests, expecting: SHGetCharactersResponse.self) { result in
            switch result {
                case .success(let model):
                    print("Example image url" + String(model.results.first?.image ?? "No image"))
                case .failure(let error):
                    print(String(describing: error))
            }
        }
        
    }
}

extension SHCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SHCharacterCollectionViewCell.identifier,
            for: indexPath) as? SHCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        let viewModel = SHCharacterCollectionViewCellViewModel(name: "Morty", status: .alive, imageUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
