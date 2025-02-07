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
    @Published var searchQuery: String = ""
    @Published var searchResults: [Movie] = []

    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkService
    private let imagePrefetcher: MovieImagePrefetching
    private var page: Int = 0
    var canLoadMore: Bool = true
    private var isLoading: Bool = false
    
    init(networkService: NetworkService = NetworkManager.shared,
         imagePrefetcher: MovieImagePrefetching = MovieImagePrefetcher()) {
        self.networkService = networkService
        self.imagePrefetcher = imagePrefetcher
        self.setupSearch()
    }
    
    func loadMoreMovies(completion: @escaping (Error?) -> Void) {
        guard canLoadMore, !isLoading else {
            completion(nil)
            return
        }
        
        isLoading = true
        page += 1
        
        networkService.fetchNowPlaying(page: page) { [weak self] result in
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
    
    private func setupSearch() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                self?.searchMovies(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func searchMovies(query: String) {
        networkService.searchMovies(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let searchResults):
                    self?.searchResults = searchResults.results
                case .failure:
                    self?.searchResults = []
                }
            }
        }
    }
    
}
