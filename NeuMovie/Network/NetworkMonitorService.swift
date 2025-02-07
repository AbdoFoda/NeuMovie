//
//  NetworkMonitorService.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//


import Network

protocol NetworkMonitorService {
    func isNetworkAvailable() -> Bool
}

final class NetworkMonitor: NetworkMonitorService {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var currentStatus: NWPath.Status = .requiresConnection

    private init() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.currentStatus = path.status
        }
    }

    func isNetworkAvailable() -> Bool {
        return currentStatus == .satisfied
    }
}
