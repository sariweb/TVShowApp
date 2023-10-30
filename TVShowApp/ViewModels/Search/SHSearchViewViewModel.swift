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
    
    public func executeSearch() {
        // Create request
        // Send API call
        // Notify view of results / no results / error
        print("executeSearch")
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
}
