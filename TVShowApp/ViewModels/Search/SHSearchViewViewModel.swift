//
//  SHSearchViewViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 26.10.2023.
//

import Foundation

final class SHSearchViewViewModel {
    private(set) var config: SHSearchViewController.Config
    
    private var optionMap: [SearchOption: String] = [:]
    private var optionMapUpdateBlock: (((SearchOption, String)) -> Void)?
    private var searchResultsHandler: ((SHSearchResultsViewModel) -> Void)?
    private var noResultsHandler: (() -> Void)?
    private var searchText = ""
    private var searchResultsModel: Codable?
    
    // MARK: - Init
    
    init(config: SHSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Private
    
    private func makeSearchAPICall<T: Codable>(_ request: SHRequest, _ type: T.Type) {
        // execute request
        SHService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
                case .success(let model):
                    // Episodes, Characters: collection view; Locations: table view
                    self?.processSearchResults(model)
                    break
                case .failure:
                    self?.handleNoResults()
            }
        }
    }
    
    private func processSearchResults(_ model: Codable) {
        var resultsVM: SHSearchResultsViewModel?
        
        if let charactersResults = model as? SHGetAllCharactersResponse {
            resultsVM = .characters(charactersResults.results.compactMap {
                return SHCharacterCollectionViewCellViewModel(
                    name: $0.name,
                    status: $0.status,
                    imageUrl: URL(string: $0.image)
                )
            })
        } else if let episodesResults = model as? SHGetAllEpisodesResponse {
            resultsVM = .episodes(episodesResults.results.compactMap {
                return SHCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            })
        } else if let locationsResults = model as? SHGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.compactMap {
                return SHLocationTableViewCellViewModel(location: $0)
            })
        } else {
            // error
        }
        
        if let results = resultsVM {
            self.searchResultsModel = model
            searchResultsHandler?(results)
        } else {
            // error
            handleNoResults()
        }
    }
    
    private func handleNoResults() {
        noResultsHandler?()
    }
    
    // MARK: - Public
    
    public func set(value: String, for option: SearchOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(
        _ block: @escaping ((SearchOption, String)) -> Void
    ) {
        self.optionMapUpdateBlock = block
    }
    
    public func registerSearchResultsHandler (
        _ block: @escaping (SHSearchResultsViewModel) -> Void
    ) {
        self.searchResultsHandler = block
    }
    
    public func registerNoResultsHandler (
        _ block: @escaping () -> Void
    ) {
        self.noResultsHandler = block
    }
    
    public func executeSearch() {
        // build args
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        
        // add options
        queryParams.append(contentsOf: optionMap.enumerated().map({ _, element in
            let key: SearchOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        
        // make request
        let request = SHRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )
        
        
        switch config.type.endpoint {
            case .character:
                makeSearchAPICall(request, SHGetAllCharactersResponse.self)
            case .episode:
                makeSearchAPICall(request, SHGetAllEpisodesResponse.self)
            case .location:
                makeSearchAPICall(request, SHGetAllLocationsResponse.self)
        }
        
        
        
        
        
        // Notify view of results / no results / error
        
    }
    
    
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func locationSearchResults(at index: Int) -> SHLocation? {
        guard let searchModel = searchResultsModel as? SHGetAllLocationsResponse else {
            return nil
        }
        
        return searchModel.results[index]
    }
}
