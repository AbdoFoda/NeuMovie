//
//  MovieImagePrefetching.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//

import Nuke

protocol MovieImagePrefetching {
    func prefetchImages(from movies: [Movie])
}

final class MovieImagePrefetcher: MovieImagePrefetching {
    private let prefetcher: ImagePrefetcher
    
    init(prefetcher: ImagePrefetcher = ImagePrefetcher()) {
        self.prefetcher = prefetcher
    }
    
    func prefetchImages(from movies: [Movie]) {
        let urls = movies.compactMap { $0.posterURL }
        prefetcher.startPrefetching(with: urls)
    }
}
