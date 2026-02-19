//
//  NetworkError.swift
//  MovieFlix
//
//  Created by Sujal on 19/02/2026.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case decodingError
    case serverError(String)
    case unknown
    case noInternet
}

extension NetworkError {
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid request. Please try again later."
        case .serverError(let message):
            return message
        case .decodingError:
            return "Failed to process data. Please try again."
        case .unknown:
            return "Something went wrong. Please try again."
        case .noInternet:
            return "No internet connection. Check your network and try again."
        }
    }
}
