//
//  NetworkManager.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 06.02.25.
//


import Foundation
import Network


public final class NetworkManager: NetworkService {
    static let shared = NetworkManager()

    private let session: URLSession
    private let networkMonitor: NetworkMonitorService

    /// Inject dependencies for flexibility & testability
    private init(session: URLSession = .shared, monitor: NetworkMonitorService = NetworkMonitor.shared) {
        self.session = session
        self.networkMonitor = monitor
    }

    private func request<T: Decodable>(endpoint: APIConstants.APIRoute,
                                       parameters: [APIConstants.Parameter: String],
                                       completion: @escaping (Result<T, NetworkError>) -> Void) {
        let result = APIConstants.buildURL(from: endpoint, queryParam: parameters)
        guard case .success(let url) = result else {
            if case .failure(let error) = result {
                    completion(.failure(error))
            }
            return
        }

        guard networkMonitor.isNetworkAvailable() else {
            completion(.failure(.noInternet))
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.request(endpoint: endpoint, parameters: parameters, completion: completion)
            }
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(APIConstants.bearerToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 20
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let mimeType = response?.mimeType, mimeType.contains("json"),
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
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed(error)))
                }
            }
        }
        task.resume()
    }

    func fetchNowPlaying(page: Int, completion: @escaping (Result<NowPlayingResponse, NetworkError>) -> Void) {
        request(endpoint: .nowPlaying,
                parameters: [.page: String(page)],
                completion: completion)
    }
    
    func searchMovies(query: String, completion: @escaping (Result<NowPlayingResponse, NetworkError>) -> Void) {
        request(endpoint: .searchPath,
                parameters: [.query: query],
                completion: completion)
    }
}
