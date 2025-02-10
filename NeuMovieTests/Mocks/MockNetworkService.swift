//
//  MockNetworkService.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//

@testable import NeuMovie

final class MockNetworkService: NetworkService {
    
    
    var mockResult: Result<NowPlayingResponse, NetworkError>?
    
    func fetchNowPlaying(page: Int, completion: @escaping (Result<NowPlayingResponse, NetworkError>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
    
    func searchMovies(query: String, completion: @escaping (Result<NeuMovie.NowPlayingResponse, NeuMovie.NetworkError>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }

}
