//
//  SHEpisodeDetailViewViewModel.swift
//  TVShowApp
//
//  Created by Sergei on 08.09.2023.
//

import Foundation

final class SHEpisodeDetailViewViewModel {
    private let endpointUrl: URL?
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData() 
    }
    
    private func fetchEpisodeData() {
        guard let url = endpointUrl,
              let request = SHRequest(url: url) else { return }
        
        SHService.shared.execute(
            request,
            expecting: SHEpisode.self
        ) { result in
            switch result {
                case .success(let success):
                    print(String(describing: success))
                case .failure(let failure):
                    print(String(describing: failure))
            }
        }
    }
}
