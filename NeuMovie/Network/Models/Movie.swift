//
//  Movie.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 06.02.25.
//


import Foundation

class Movie: Codable, Identifiable {
    let id: Int
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Float
    let popularity: Float
    let title: String
    let overview: String
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: APIConstants.imageBaseURL + path)
    }
}

extension Movie: Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
