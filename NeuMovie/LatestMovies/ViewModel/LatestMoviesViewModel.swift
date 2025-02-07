//
//  LatestMoviesViewModel.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 06.02.25.
//

import Combine
import SwiftUI

final class LatestMoviesViewModel: LatestMoviesViewModelProtocol {
    
    @Published private(set) var moviesToDisplay: [Movie] = []
    
    private let networkManager: NetworkManager
    private let imagePrefetcher: MovieImagePrefetching
    private var page: Int = 0
    private var canLoadMore: Bool = true
    private var isLoading: Bool = false
    
    init(networkManager: NetworkManager = .shared,
         imagePrefetcher: MovieImagePrefetching = MovieImagePrefetcher()) {
        self.networkManager = networkManager
        self.imagePrefetcher = imagePrefetcher
    }
    
    func loadMoreMovies(completion: @escaping (Error?) -> Void) {
        guard canLoadMore, !isLoading else {
            completion(nil)
            return
        }
        
        isLoading = true
        page += 1
        
        networkManager.fetchNowPlaying(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let nowPlaying):
                self.handleNewMovies(nowPlaying.results)
                self.canLoadMore = nowPlaying.totalPages > self.page
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    private func handleNewMovies(_ newMovies: [Movie]) {
        let uniqueMovies = Set(moviesToDisplay).union(newMovies)
        DispatchQueue.main.async {
            self.moviesToDisplay = Array(uniqueMovies)
            self.imagePrefetcher.prefetchImages(from: newMovies)
        }
    }
}
