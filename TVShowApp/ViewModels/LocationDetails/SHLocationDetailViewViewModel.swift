//
//  SHLocationDetailViewViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 22.10.2023.
//

import Foundation

protocol SHLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class SHLocationDetailViewViewModel {
    private let endpointUrl: URL?
    private var locationData: (location: SHLocation, characters: [SHCharacter])? {
        didSet {
            createCellVieModels()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [SHEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [SHCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate: SHLocationDetailViewViewModelDelegate?
    
    private(set) var cellViewModels: [SectionType] = []
    
    public func character(at index: Int) -> SHCharacter? {
        guard let locationData else { return nil }
        return locationData.characters[index]
    }
    
    // MARK: - Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: - Private
    
    private func createCellVieModels() {
        guard let locationData else { return }
        let location = locationData.location
        let characters = locationData.characters
        
        var createdString = location.created
        if let date = SHCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = SHCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Created", value: createdString),
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
    
    /// Fetch backing location model
    public func fetchLocationData() {
        guard let url = endpointUrl,
              let request = SHRequest(url: url) else { return }
        
        SHService.shared.execute(
            request,
            expecting: SHLocation.self
        ) { [weak self] result in
            switch result {
                case .success(let model):
                    self?.fetchRelatedCharacters(location: model)
                case .failure(let failure):
                    print(String(describing: failure))
            }
        }
    }
    
    private func fetchRelatedCharacters(location: SHLocation) {
        let requests: [SHRequest] = location.residents
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
            self.locationData = (
                location: location,
                characters: characters
            )
        }
    }
}
