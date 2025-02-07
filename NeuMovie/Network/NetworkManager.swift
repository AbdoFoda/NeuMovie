//
//  NetworkManager.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 06.02.25.
//


import Foundation

public class NetworkManager: NetworkService {
    static let shared = NetworkManager()
    
    private let session: URLSession
    
    /// Inject `URLSession` for flexibility & testability
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Generic request handler to scale better
    private func request<T: Decodable>(endpoint: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: APIConstants.baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(APIConstants.bearerToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10 // Set timeout to avoid hanging requests

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType == "application/json",
                  let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(.decodingFailed(error)))
            }
        }
        task.resume()
    }
    
    func fetchNowPlaying(page: Int, completion: @escaping (Result<NowPlayingResponse, NetworkError>) -> Void) {
        request(endpoint: "movie/now_playing?page=\(page)", completion: completion)
    }
}
