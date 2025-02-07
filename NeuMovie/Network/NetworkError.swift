//
//  NetworkError.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 06.02.25.
//


enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}
