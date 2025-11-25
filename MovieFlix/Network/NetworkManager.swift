//
//  NetworkManager.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import Foundation

public protocol DataModel: Codable {}
public protocol Request: Codable {}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public protocol NetworkServiceProtocol {
    func execute<T: DataModel>(
        urlRequest: NetworkURLRequest,
        request: Request?,
        model: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

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
            return "\(message). Please try again later."
        case .decodingError:
            return "Failed to process data. Please try again."
        case .unknown:
            return "Something went wrong. Please try again."
        case .noInternet:
            return "No internet connection. Check your network and try again."
        }
    }
}

public protocol NetworkURLRequest {
    var baseURL: String { get }
    var path: String { get }
    var requestURL: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}

class NetworkManager: NetworkServiceProtocol {
    static let shared = NetworkManager()
    
    private init() {}
    
    public func execute<T: DataModel>(
        urlRequest: NetworkURLRequest,
        request: Request? = nil,
        model: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlRequest.requestURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        debugPrint("URL: ", url)
        
        var urlRequestObj = URLRequest(url: url)
        urlRequestObj.httpMethod = urlRequest.method.rawValue
        
        debugPrint("Method: ", urlRequest.method.rawValue)
        
        if let headers = urlRequest.headers {
            for (key, value) in headers {
                urlRequestObj.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        debugPrint("Headers: ", urlRequest.headers ?? [])
        
        if let requestBody = request {
            debugPrint("Request: ", requestBody)
            do {
                let data = try JSONEncoder().encode(requestBody)
                urlRequestObj.httpBody = data
            } catch {
                completion(.failure(.decodingError))
                return
            }
        }
        
        URLSession.shared.dataTask(with: urlRequestObj) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                debugPrint("Status Code:", httpResponse.statusCode)
            }
            
            if let data = data {
                let jsonString = String(data: data, encoding: .utf8) ?? "Unable to convert data to UTF8 string"
                debugPrint("JSON RESPONSE:", jsonString)
            }
            
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    if error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                        completion(.failure(.noInternet))
                    } else {
                        completion(.failure(.serverError(error.localizedDescription)))
                    }
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.unknown))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
