//
//  NetworkManagerEnums.swift
//  Project0
//
//  Created by Kaan on 21.11.2024.
//

import Foundation

// MARK: - Endpoint Protocol
protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents(string: baseURL + path)
        if let queryParameters = queryParameters {
            components?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        return components?.url
    }
}

// MARK: - HTTP Methods
enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

// MARK: - NetworkError Enum
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(statusCode: Int)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noData: return "No data received from the server."
        case .decodingError: return "Failed to decode the response."
        case .serverError(let statusCode): return "Server error with status code \(statusCode)."
        case .unknownError: return "An unknown error occurred."
        }
    }
}
