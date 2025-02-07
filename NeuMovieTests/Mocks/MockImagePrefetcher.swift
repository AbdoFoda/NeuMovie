//
//  MockImagePrefetcher.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//

@testable import NeuMovie

final class MockImagePrefetcher: MovieImagePrefetching {
    var didPrefetch = false
    var prefetchCount = 0

    func prefetchImages(from movies: [Movie]) {
        didPrefetch = true
        prefetchCount += movies.count
    }
}
