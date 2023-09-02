//
//  SHCharacterListViewViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 27.08.2023.
//

import UIKit

protocol SHCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: SHCharacter)
}

/// ViewModel to handle charcter list view logic
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
                
                if !cellViewModels.contains(viewModel) { cellViewModels.append(viewModel) }
            }
        }
    }
    
    private var cellViewModels: [SHCharacterCollectionViewCellViewModel] = []
    private var apiInfo: SHGetCharactersResponse.Info? = nil
    private var isLoadingMoreCharacters = false
    
    /// Fetch initial set of characters (20)
    func fetchCharacters() {
        SHService.shared.execute(
            .listCharacterRequests,
            expecting: SHGetCharactersResponse.self
        ) { [weak self] result in
            switch result {
                case .success(let responseModel):
                    let results = responseModel.results
                    let info = responseModel.info
                    self?.characters = results
                    self?.apiInfo = info
                    
                    DispatchQueue.main.async {
                        self?.delegate?.didLoadInitialCharacters()
                    }
                case .failure(let error):
                    print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else {
            return
        }
        isLoadingMoreCharacters = true
        
        guard let request = SHRequest(url: url) else {
            
            return
        }
        
        SHService.shared.execute(
            request,
            expecting: SHGetCharactersResponse.self) { [weak self] result in
                guard let self else { return }
                switch result {
                    case .success(let responseModel):
                        let moreResults = responseModel.results
                        let info = responseModel.info
                        self.apiInfo = info
                        let originalCount = self.characters.count
                        let newCount = moreResults.count
                        let total = originalCount + newCount
                        let startIndex = originalCount
                        let indexPathsToAdd: [IndexPath] = Array(startIndex..<total).compactMap { IndexPath(row: $0, section: 0) }
                        self.characters.append(contentsOf: moreResults)
                        DispatchQueue.main.async {
                            self.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                            self.isLoadingMoreCharacters = false
                        }
                    case .failure(let failure):
                        self.isLoadingMoreCharacters = false
                        print(String(describing: failure))
                }
            }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - CollectionView

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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SHFooterLoadingCollectionReusableView.identifier,
            for: indexPath) as? SHFooterLoadingCollectionReusableView else { fatalError("Unsupported")
        }
        
        footer.startAnimating()
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

// MARK: - ScrollView

extension SHCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString)
        else { return }

        Timer.scheduledTimer(withTimeInterval: 0.0,
                             repeats: false) { [weak self] t in
            
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120),
               totalContentHeight > 0 {
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate()
        }
    }
}
