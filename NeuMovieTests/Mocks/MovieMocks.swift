//
//  MovieMocks.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//

struct MovieMockData {
    static let sampleMovies: [Movie] = (1...50).map { index in
        Movie(
            id: index,
            posterPath: index % 3 == 0 ? nil : "/sample\(index).jpg", // Every third movie has no poster
            releaseDate: "202\(index % 5)-0\(index % 9 + 1)-\(index % 28 + 1)", // Varies the year/month/day
            voteAverage: Float.random(in: 5.0...9.5),
            popularity: Float.random(in: 40.0...120.0),
            title: "Sample Movie \(index)",
            overview: "This is a sample overview for movie \(index). It contains a brief description."
        )
    }
    
    static let singleMovie = Movie(
        id: 99,
        posterPath: "/single.jpg",
        releaseDate: "2025-07-07",
        voteAverage: 7.2,
        popularity: 95.3,
        title: "Single Mock Movie",
        overview: "This is a single mock movie for testing purposes."
    )
}
