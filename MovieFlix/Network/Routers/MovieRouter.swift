//
//  MovieRouter.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import Foundation

public enum MovieRouter {
    case searchMovie(query: String, page: Int)
//    case movieDetails(id: Int)
}

extension MovieRouter: NetworkURLRequest {
    
    public var baseURL: String {
        return ApiConstants.fullBaseUrl
    }
    
    public var path: String {
        switch self {
        case .searchMovie: ApiConstants.movieSearch
        }
    }
    
    public var requestURL: String {
        switch self {
        case .searchMovie(let query, let page): return "\(baseURL)\(path)?query=\(query)&page=\(page)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .searchMovie: return .get
        }
    }
    
    public var headers: [String: String]? {
        return [
            "Authorization": "Bearer \(ApiConstants.apiKey)",
            "Content-Type": "application/json"
        ]
    }
}
