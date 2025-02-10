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
        guard var path = posterPath else { return nil }
        if path.hasPrefix("/") {
            path.removeFirst()
        }
        if case .success(let url) = APIConstants.buildURL(isImage: true,
                                                          pathParam: [APIConstants.defaultImageSize, path]){
            return url
        }
        return nil
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.voteAverage = try container.decode(Float.self, forKey: .voteAverage)
        self.popularity = try container.decode(Float.self, forKey: .popularity)
        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)
    }
    
    init(id: Int, posterPath: String? = nil, releaseDate: String, voteAverage: Float, popularity: Float, title: String, overview: String) {
        self.id = id
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.popularity = popularity
        self.title = title
        self.overview = overview
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
