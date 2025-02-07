//
//  NetworkService.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 06.02.25.
//


protocol NetworkService {
    func fetchNowPlaying(page: Int, completion: @escaping (Result<NowPlayingResponse, NetworkError>) -> Void)
}
