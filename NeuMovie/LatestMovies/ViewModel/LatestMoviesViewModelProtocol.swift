//
//  LatestMoviesViewModelProtocol.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 06.02.25.
//

import Combine

protocol LatestMoviesViewModelProtocol: ObservableObject {
    var moviesToDisplay: [Movie] { get }
    func loadMoreMovies(completion: @escaping (Error?) -> Void)
}
