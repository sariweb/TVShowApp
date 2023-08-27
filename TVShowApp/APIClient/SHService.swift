//
//  SHService.swift
//  TVShowApp
//
//  Created by Sergei on 27.08.2023.
//

import Foundation

/// Primary API service to get data
final class SHService {
    /// Shared siglton instace
    static let shared = SHService()
    
    /// Privatized constractor
    private init() {}
    
    enum SHServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send API call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of an object we expect to get back
    ///   - complition: Callback with data or error
    public func execute<T: Codable>(
        _ request: SHRequest,
        expecting type: T.Type,
        complition: @escaping (Result<T, Error>) -> Void
    ) {
        guard let urlRequest = self.request(from: request) else {
            complition(.failure(SHServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                complition(.failure(error ?? SHServiceError.failedToGetData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                complition(.success(result))
            }
            catch {
                complition(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func request(from shRequest: SHRequest) -> URLRequest? {
        guard let url = shRequest.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = shRequest.httpMethod
        
        return request
    }
}
