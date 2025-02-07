//
//  LatestMoviesViewModel.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 06.02.25.
//

import Combine
import Foundation

final class LatestMoviesViewModel: LatestMoviesViewModelProtocol {
    
    @Published var moviesToDisplay: [Movie] = [Movie]()
    var networkManager: NetworkManager
    
    private var page: Int = 0
    private var canLoadMore: Bool = true
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func loadMoreMovies(completion: @escaping (Error?) -> Void) {
        guard canLoadMore else {
            print("All Movies are loaded")
            completion(.none)
            return
        }
        page += 1
        NetworkManager().fetchNowPlaying(page: self.page) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let nowPlaying):
                self.canLoadMore = (nowPlaying.totalPages > self.page)
                let newMovies = Array(Set(nowPlaying.results))
                DispatchQueue.main.async { [weak self] in
                    if let self = self {
                        self.moviesToDisplay = Array(Set(self.moviesToDisplay + newMovies))
                    }
                }
                completion(nil)
            case .failure(let error):
                print(error)
                completion(error)
            }
            
        }
    }
    
    
}
