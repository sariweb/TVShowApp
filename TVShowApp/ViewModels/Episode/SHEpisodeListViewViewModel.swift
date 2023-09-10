//
//  SHEpisodeListViewViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 09.09.2023.
//

import UIKit

protocol SHEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode: SHEpisode)
}

/// ViewModel to handle episode list view logic
final class SHEpisodeListViewViewModel: NSObject {
    weak var delegate: SHEpisodeListViewViewModelDelegate?
    
    private let borderColors: [UIColor] = [
        .systemRed,
        .systemBlue,
        .systemCyan,
        .systemMint,
        .systemPink,
        .systemTeal,
        .systemGreen,
        .systemOrange,
        .systemYellow
    ]
    
    private var episodes: [SHEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = SHCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url),
                    borderColor: borderColors.randomElement() ?? .systemBlue
                )
                
                if !cellViewModels.contains(viewModel) { cellViewModels.append(viewModel) }
            }
        }
    }
    
    private var cellViewModels: [SHCharacterEpisodeCollectionViewCellViewModel] = []
    private var apiInfo: SHGetAllEpisodesResponse.Info? = nil
    private var isLoadingMoreEpisodes = false
    
    /// Fetch initial set of episodes (20)
    func fetchEpisodes() {
        SHService.shared.execute(
            .listEpisodeRequest,
            expecting: SHGetAllEpisodesResponse.self
        ) { [weak self] result in
            switch result {
                case .success(let responseModel):
                    let results = responseModel.results
                    let info = responseModel.info
                    self?.episodes = results
                    self?.apiInfo = info
                    
                    DispatchQueue.main.async {
                        self?.delegate?.didLoadInitialEpisodes()
                    }
                case .failure(let error):
                    print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional episodes are needed
    public func fetchAdditionalEpisodes(url: URL) {
        guard !isLoadingMoreEpisodes else {
            return
        }
        isLoadingMoreEpisodes = true
        
        guard let request = SHRequest(url: url) else { return }
        
        SHService.shared.execute(
            request,
            expecting: SHGetAllEpisodesResponse.self) { [weak self] result in
                guard let self else { return }
                switch result {
                    case .success(let responseModel):
                        let moreResults = responseModel.results
                        let info = responseModel.info
                        self.apiInfo = info
                        let originalCount = self.episodes.count
                        let newCount = moreResults.count
                        let total = originalCount + newCount
                        let startIndex = originalCount
                        let indexPathsToAdd: [IndexPath] = Array(startIndex..<total).compactMap { IndexPath(row: $0, section: 0) }
                        self.episodes.append(contentsOf: moreResults)
                        DispatchQueue.main.async {
                            self.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
                            self.isLoadingMoreEpisodes = false
                        }
                    case .failure(let failure):
                        self.isLoadingMoreEpisodes = false
                        print(String(describing: failure))
                }
            }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - CollectionView

extension SHEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SHCharacterEpisodeCollectionViewCell.identifier,
            for: indexPath) as? SHCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = bounds.width - 20
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
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

extension SHEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreEpisodes,
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
                self?.fetchAdditionalEpisodes(url: url)
            }
            t.invalidate()
        }
    }
}
