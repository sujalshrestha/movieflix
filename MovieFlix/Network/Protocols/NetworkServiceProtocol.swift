//
//  NetworkServiceProtocol.swift
//  MovieFlix
//
//  Created by Sujal on 19/02/2026.
//

import Foundation

public protocol NetworkServiceProtocol {
    func execute<T: DataModel>(
        urlRequest: NetworkURLRequest,
        request: Request?
    ) async throws -> T
}
