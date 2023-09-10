//
//  SHEpisodeDetailViewViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 08.09.2023.
//

import Foundation

protocol SHEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class SHEpisodeDetailViewViewModel {
    private let endpointUrl: URL?
    private var episodeData: (episode: SHEpisode, characters: [SHCharacter])? {
        didSet {
            createCellVieModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [SHEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [SHCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate: SHEpisodeDetailViewViewModelDelegate?
    
    private(set) var cellViewModels: [SectionType] = []
    
    // MARK: - Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: - Private
    
    private func createCellVieModels() {
        guard let episodeData else { return }
        let episode = episodeData.episode
        let characters = episodeData.characters
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.airDate),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: episode.created),
            ]),
            .characters(viewModels: characters.compactMap {
                SHCharacterCollectionViewCellViewModel(
                    name: $0.name,
                    status: $0.status,
                    imageUrl: URL(string: $0.image)
                )
            })
        ]
    }
    
    // MARK: - Public
    
    /// Fetch backing episode model
    public func fetchEpisodeData() {
        guard let url = endpointUrl,
              let request = SHRequest(url: url) else { return }
        
        SHService.shared.execute(
            request,
            expecting: SHEpisode.self
        ) { [weak self] result in
            switch result {
                case .success(let model):
                    self?.fetchRelatedCharacters(episode: model)
                case .failure(let failure):
                    print(String(describing: failure))
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: SHEpisode) {
        let requests: [SHRequest] = episode.characters
            .compactMap { URL(string: $0)}
            .compactMap { SHRequest(url: $0) }
        
        let group = DispatchGroup()
        var characters: [SHCharacter] = []
        for request in requests {
            group.enter()
            SHService.shared.execute(request,
                                     expecting: SHCharacter.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                    case .success(let model):
                        characters.append(model)
                    case .failure:
                        break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.episodeData = (
                episode: episode,
                characters: characters
            )
        }
    }
}
