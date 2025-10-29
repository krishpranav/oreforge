//
//  PoolConnectionService.swift
//  OreForge
//
//  Created by Krisna Pranav on 29/10/25.
//

import Foundation

class PoolConnectionService: NSObject, ObservableObject {
    @Published var isConnected: Bool = false
    @Published var currentPool: MiningPool?
    @Published var poolStatus: String = "Disconnected"

    private var urlSession: URLSession?
    private var webSocketTask: URLSessionWebSocketTask?

    override init() {
        super.init()
        setupSession()
    }

    private func setupSession() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        urlSession = URLSession(configuration: config)
    }

    func connect(to pool: MiningPool) {
        guard let urlSession = urlSession else { return }

        let wsURL = URL(string: "ws://\(pool.address):\(pool.port)")!
        webSocketTask = urlSession.webSocketTask(with: wsURL)
        webSocketTask?.resume()

        currentPool = pool
        isConnected = true
        poolStatus = "Connected to \(pool.name)"

        receiveMessage()
    }

    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self?.poolStatus = "Received: \(text.prefix(50))..."
                    }
                case .data(let data):
                    DispatchQueue.main.async {
                        self?.poolStatus = "Data received: \(data.count) bytes"
                    }
                @unknown default:
                    break
                }
                self?.receiveMessage()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.poolStatus = "Connection error: \(error.localizedDescription)"
                    self?.isConnected = false
                }
            }
        }
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
        poolStatus = "Disconnected"
    }

    deinit {
        disconnect()
    }
}
