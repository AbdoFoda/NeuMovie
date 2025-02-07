//
//  NetworkError 2.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//


import Foundation

enum NetworkError: Error {
    case invalidURL
    case noInternet
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .noInternet:
            return "No internet connection."
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from the server."
        case .decodingFailed:
            return "Failed to decode the response."
        }
    }
}
