//
//  SHCharacterEpisodeCollectionViewCellViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 04.09.2023.
//

import UIKit

protocol SHEpisodeDataRender {
    var name: String { get }
    var airDate: String { get }
    var episode: String { get }
}

final class SHCharacterEpisodeCollectionViewCellViewModel {
    private let episodeDataUrl: URL?
    private var isFetching = false
    private var dataBlock: ((SHEpisodeDataRender) -> Void)?
    
    private var episode: SHEpisode? {
        didSet {
            guard let model = episode else { return }
            dataBlock?(model)
        }
    }
    
    
    // MARK: - Init
    
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
    
    
    // MARK: - Public functions
    
    public func registerForData(_ block: @escaping (SHEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        guard let url = episodeDataUrl, let request = SHRequest(url: url) else { return }
        
        isFetching = true
        
        SHService.shared.execute(request,
                                 expecting: SHEpisode.self) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        self.episode = model
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    
            }
        }
    }
}


// MARK: - Hashable & Equatable

extension SHCharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {
    static func == (lhs: SHCharacterEpisodeCollectionViewCellViewModel,
                    rhs: SHCharacterEpisodeCollectionViewCellViewModel
    ) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(episodeDataUrl?.absoluteString ?? "")
    }
}
