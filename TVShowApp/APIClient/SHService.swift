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
    
    /// Send API call
    /// - Parameters:
    ///   - request: Request instance
    ///   - complition: Callback with data or error
    public func execute(_ request: SHRequest, complition: @escaping () -> Void) {
        
    }
}
