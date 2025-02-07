//
//  APIConstants.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 06.02.25.
//


enum APIConstants {
    static let baseURL = "https://api.themoviedb.org/3/"
    // TODO: for security reasons, token should be fetched from internal API/backend.
    static private let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMTAwYTVkNDNlNDZhYTgzZTA0ZGJjMzA2ZDE2MzgxYSIsIm5iZiI6MTczODE4MDQ3Ni43NCwic3ViIjoiNjc5YTg3N2NiMjM2MjllN2Y4ZmJiOWE0Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.UFCfw_Ra8sFtm_z8P6_7t5afF5VallqN2BrnxYE9Uc8"
    
    static let bearerToken = "Bearer \(token)"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    static let nowPlayingPath = "movie/now_playing?page="
    static let searchPath = "search/movie?query="
}
