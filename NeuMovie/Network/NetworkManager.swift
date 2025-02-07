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

    private func buildURL(endpoint: String) -> URL? {
        return URL(string: APIConstants.baseURL + endpoint)
    }


    private func request<T: Decodable>(endpoint: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = buildURL(endpoint: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        guard networkMonitor.isNetworkAvailable() else {
            completion(.failure(.noInternet))
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.request(endpoint: endpoint, completion: completion)
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
        request(endpoint: "movie/now_playing?page=\(page)", completion: completion)
    }
}
