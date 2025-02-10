//
//  APIConstants.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 06.02.25.
//

import Foundation

enum APIConstants {
    static let baseURL = "https://api.themoviedb.org/3/"
    // TODO: for security reasons, token should be fetched from internal API/backend.
    static private let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMTAwYTVkNDNlNDZhYTgzZTA0ZGJjMzA2ZDE2MzgxYSIsIm5iZiI6MTczODE4MDQ3Ni43NCwic3ViIjoiNjc5YTg3N2NiMjM2MjllN2Y4ZmJiOWE0Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.UFCfw_Ra8sFtm_z8P6_7t5afF5VallqN2BrnxYE9Uc8"
    
    static let bearerToken = "Bearer \(token)"
    static let imageBaseURL = "https://image.tmdb.org/t/p/"
    static let defaultImageSize = "w500"
    enum APIRoute: String {
        case nowPlaying = "movie/now_playing"
        case searchPath = "search/movie"
        case none = ""
    }
    
    enum Parameter: String {
        case page = "page"
        case query = "query"
    }
    
    static func buildURL(isImage: Bool = false,
                         from route: APIRoute = .none,
                         pathParam: [String] = [],
                         queryParam param: [Parameter: String] = [:])
    -> Result<URL, NetworkError> {
        var urlString = "\(isImage ? imageBaseURL : baseURL)"
        urlString += route.rawValue
        

        guard var urlComponents = URLComponents(string: urlString) else {
            return .failure(.invalidURL)
        }
        
        if !pathParam.isEmpty {
            urlComponents.path.append("/" + pathParam.joined(separator: "/"))
        }
        
        var queryItems: [URLQueryItem] = []
        for (key, value) in param {
            let queryItem = URLQueryItem(name: key.rawValue, value: value)
            queryItems.append(queryItem)
        }
        urlComponents.queryItems = queryItems
        if let url = urlComponents.url {
            return .success(url)
        }
        return .failure(.invalidURL)
    }
}
