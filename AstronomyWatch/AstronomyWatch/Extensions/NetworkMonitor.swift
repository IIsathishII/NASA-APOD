//
//  NetworkMonitor.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 26/03/23.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    
    var callback: ((NWPath) -> ())? = nil
    
    private init() {

    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.callback?(path)
            print("Status :: ", path.status)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
