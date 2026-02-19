//
//  NetworkManager.swift
//  MovieFlix
//
//  Created by Sujal on 24/11/2025.
//

import Foundation

actor NetworkManager: NetworkServiceProtocol {
    static let shared = NetworkManager()

    private init() {}

    public func execute<T: DataModel>(
        urlRequest: NetworkURLRequest,
        request: Request? = nil
    ) async throws -> T {
        guard let url = URL(string: urlRequest.requestURL) else {
            throw NetworkError.invalidURL
        }

#if DEBUG
        debugPrint("URL: ", url)
#endif

        var urlRequestObj = URLRequest(url: url)
        urlRequestObj.httpMethod = urlRequest.method.rawValue
        urlRequestObj.timeoutInterval = 60

#if DEBUG
        debugPrint("Method: ", urlRequest.method.rawValue)
#endif

        if let headers = urlRequest.headers {
            for (key, value) in headers {
                urlRequestObj.setValue(value, forHTTPHeaderField: key)
            }
        }

#if DEBUG
        debugPrint("Headers: ", urlRequest.headers ?? [])
#endif

        if let requestBody = request {
#if DEBUG
            debugPrint("Request: ", requestBody)
#endif
            do {
                let data = try JSONEncoder().encode(requestBody)
                urlRequestObj.httpBody = data
            } catch {
                throw NetworkError.decodingError
            }
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequestObj)

#if DEBUG
            if let httpResponse = response as? HTTPURLResponse {
                debugPrint("Status Code:", httpResponse.statusCode)
            }

            let jsonString = String(data: data, encoding: .utf8) ?? "Unable to convert data to UTF8 string"
            debugPrint("JSON RESPONSE:", jsonString)
#endif

            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch let error as URLError where error.code == .notConnectedToInternet {
            throw NetworkError.noInternet
        } catch is DecodingError {
            throw NetworkError.decodingError
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.serverError(error.localizedDescription)
        }
    }
}
