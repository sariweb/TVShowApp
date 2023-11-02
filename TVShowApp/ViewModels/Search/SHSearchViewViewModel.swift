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
    private var searchResultsHandler: (() -> Void)?
    private var searchText = ""
    
    // MARK: - Init
    
    init(config: SHSearchViewController.Config) {
        self.config = config
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
        _ block: @escaping () -> Void
    ) {
        self.searchResultsHandler = block
    }
    
    public func executeSearch() {
        // test search
        print("Search text: \(searchText)")
        
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
        
        print(request.url?.absoluteString)
        
        // execute request
        SHService.shared.execute(request, expecting: SHGetAllCharactersResponse.self) { result in
            switch result {
                case .success(let model):
                    print("Search results found: \(model.results.count)")
                case .failure:
                    break
            }
        }
        
        // Notify view of results / no results / error
        
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
}
