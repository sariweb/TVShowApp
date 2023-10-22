//
//  SHLocationViewViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 22.10.2023.
//

import UIKit

protocol SHLocationViewViewModelDelegate: AnyObject {
    func didLoadInitialLocations()
//    func didLoadMoreLocations(with newIndexPaths: [IndexPath])
//    func didSelectLocation(_ location: SHLocation)
}

final class SHLocationViewViewModel {
    private var locations: [SHLocation] = [] {
        didSet {
            for location in locations {
                let viewModel = SHLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    private var apiInfo: SHGetAllLocationsResponse.Info? = nil
    private(set) var cellViewModels: [SHLocationTableViewCellViewModel] = []
    
    weak var delegate: SHLocationViewViewModelDelegate?
    
    public func location(at index: Int) -> SHLocation? {
        guard index < locations.count else { return nil }
        return locations[index]
    }
    
    init() {}
    
    public func fetchLocations() {
        SHService.shared.execute(
            .listLocationsRequest,
            expecting: SHGetAllLocationsResponse.self
        ) { [weak self] result in
            switch result {
                case .success(let responseModel):
                    let results = responseModel.results
                    let info = responseModel.info
                    self?.locations = results
                    self?.apiInfo = info
                    
                    DispatchQueue.main.async {
                        self?.delegate?.didLoadInitialLocations()
                    }
                case .failure(let error):
                    print(String(describing: error))
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
