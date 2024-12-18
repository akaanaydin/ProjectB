//
//  NetworkManager.swift
//  Project0
//
//  Created by Kaan on 21.11.2024.
//

import Foundation

// MARK: - NetworkManager
final class NetworkManager {
    static let shared = NetworkManager()
    private let urlSession: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.urlSession = URLSession(configuration: configuration)
    }
    
    func request<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let headers = endpoint.headers {
            headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        }
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw error is DecodingError ? NetworkError.decodingError : NetworkError.unknownError
        }
    }
}
