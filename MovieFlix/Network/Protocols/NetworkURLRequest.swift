//
//  NetworkURLRequest.swift
//  MovieFlix
//
//  Created by Sujal on 19/02/2026.
//

import Foundation

public protocol NetworkURLRequest {
    nonisolated var baseURL: String { get }
    nonisolated var path: String { get }
    nonisolated var requestURL: String { get }
    nonisolated var method: HTTPMethod { get }
    nonisolated var headers: [String: String]? { get }
}
