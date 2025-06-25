//
//  SocketStream.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//


import Foundation
import OSLog

class SocketStream: AsyncSequence {
    
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: SocketStream.self)
    )
    
    typealias AsyncIterator = AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>.Iterator
    typealias Element = URLSessionWebSocketTask.Message
    
    private var continuation: AsyncThrowingStream<URLSessionWebSocketTask.Message, Error>.Continuation?
    let task: URLSessionWebSocketTask
    
    private lazy var stream: AsyncThrowingStream<URLSessionWebSocketTask.Message, Error> = {
        return AsyncThrowingStream<URLSessionWebSocketTask.Message, Error> { continuation in
            self.continuation = continuation
            
            Task {
                var isAlive = true
                
                while isAlive && task.closeCode == .invalid {
                    do {
                        let value = try await task.receive()
                        continuation.yield(value)
                    } catch {
                        continuation.finish(throwing: error)
                        isAlive = false
                    }
                }
            }
        }
    }()
    
    init(task: URLSessionWebSocketTask) {
        self.task = task
        task.resume()
        SocketStream.logger.info("Opened stream")
    }
    
    deinit {
        continuation?.finish()
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        return stream.makeAsyncIterator()
    }
    
    func cancel() async throws {
        task.cancel(with: .goingAway, reason: nil)
        continuation?.finish()
        SocketStream.logger.info("Closed stream")
    }
    
    func send(command: String, params: [String:Any]? = nil, messageId: Int, remoteId: String) async throws {
        
        let paramsToUse = params ?? [
            "verb": "get",
            "format": "json"
        ]
        
        let payload = [
            "hubId": remoteId,
            "timeout": 30,
            "hbus": [
                "cmd": command,
                "id": messageId,
                "params": paramsToUse
            ]
        ] as [String : Any]
        
        let data = try JSONSerialization.data(withJSONObject: payload)
        
        try await task.send(.data(data))
        SocketStream.logger.debug("Sent command: \(command, privacy: .public)")
    }
}
