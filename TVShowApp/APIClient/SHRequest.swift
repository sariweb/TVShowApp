//
//  SHRequest.swift
//  TVShowApp
//
//  Created by Sergei on 27.08.2023.
//

import Foundation

/// Object that represent a single API call
final class SHRequest {
    
    /// API constants
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    /// Desired endpoint
    private let endpoint: SHEndpoint
    
    /// Path components for API if any
    private let pathComponents: [String]
    
    /// Query parameters for API if any
    private let queryParameters: [URLQueryItem]
    
    /// Constracted url for api request in string format
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argString = queryParameters.compactMap {
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            string += argString
        }
        return string
    }
    // MARK: - Public
    
    /// Computed and constracted API url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired http method
    public let httpMethod = "GET"
    
    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of path components
    ///   - queryParameters: Collection for query parameters
    init(endpoint: SHEndpoint,
         pathComponents: [String] = [],
         queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}

extension SHRequest {
    static let listCharacterRequests = SHRequest(endpoint: .character)
}
