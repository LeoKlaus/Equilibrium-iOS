//
//  WebSockets.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 24.06.25.
//

import Foundation
import EquilibriumAPI
import OSLog
import EasyErrorHandling

extension HubConnectionHandler {
    func connectToStatusWebsocket() async throws  {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        let webSocketTask = try apiHandler.openWebsocket(endpoint: .wsStatus)
        
        try await self.closeStatusWebsocket()
        
        self.socketStream = SocketStream(task: webSocketTask)
        
        Self.logger.info("Connected to status websocket!")
        
        Task {
            guard let socketStream else {
                Self.logger.error("Couldn't get socket stream")
                return
            }
            
            do {
                for try await message in socketStream {
                    switch message {
                    case .data(let data):
                        self.currentSceneStatus = try JSONDecoder().decode(SceneStatusReport.self, from: data)
                    case .string(let string):
                        guard let data = string.data(using: .utf8) else {
                            Self.logger.error("Received string from hub but couldn't convert to data")
                            DispatchQueue.main.async {
                                ErrorHandler.shared.handle("Received invalid websocket message", while: "Receiving websocket")
                            }
                            break
                        }
                        self.currentSceneStatus = try JSONDecoder().decode(SceneStatusReport.self, from: data)
                    @unknown default:
                        Self.logger.error("Received unknown response")
                        DispatchQueue.main.async {
                            ErrorHandler.shared.handle("Received websocket message of unknown type", while: "Receiving websocket")
                        }
                    }
                }
            } catch {
                Self.logger.error("Encountered an error parsing hub response: \(error.localizedDescription, privacy: .public)")
                DispatchQueue.main.async {
                    ErrorHandler.shared.handle("Received websocket message of unknown type", while: "Receiving websocket")
                }
            }
            
            Self.logger.info("Stream closed.")
        }
    }
    
    
    public func closeStatusWebsocket() async throws {
        try await socketStream?.cancel()
    }
    
    
    public func createIrCommand(command: Command, callback: (IrResponse) -> Void) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        guard command.type == .ir else {
            throw HubConnectionError.invalidInput
        }
        
        let webSocketTask = try apiHandler.openWebsocket(endpoint: .wsCommands)
        
        webSocketTask.resume()
        
        let encodedCommand = try JSONEncoder().encode(command)
        
        guard let commandString = String(data: encodedCommand, encoding: .utf8) else {
            throw HubConnectionError.invalidInput
        }
        
        try await webSocketTask.send(.string(commandString))
        
        var runLoop: Bool = true
        
        try await withTaskCancellationHandler {
            while runLoop {
                
                let receivedMessage = try await withTaskCancellationHandler {
                    try await webSocketTask.receive()
                } onCancel: {
                    webSocketTask.cancel(with: .normalClosure, reason: nil)
                }
                
                let response: IrResponse
                
                switch receivedMessage {
                case .data(let data):
                    response = try JSONDecoder().decode(IrResponse.self, from: data)
                case .string(let string):
                    response = try JSONDecoder().decode(IrResponse.self, from: Data(string.utf8))
                @unknown default:
                    webSocketTask.cancel(with: .internalServerError, reason: nil)
                    throw HubConnectionError.invalidServerResponse
                }
                
                callback(response)
                
                if case .done = response {
                    break
                } else if case .cancelled = response {
                    break
                }
            }
        } onCancel: {
            webSocketTask.cancel(with: .normalClosure, reason: nil)
            DispatchQueue.main.async {
                runLoop = false
                Self.logger.info("Ir recording task was cancelled, closing websocket...")
            }
            return
        }
        
        webSocketTask.cancel(with: .normalClosure, reason: nil)
    }
    
    /*public func advertiseBleKeyboard() async throws -> BleSuccessResponse {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        let webSocketTask = try apiHandler.openWebsocket(path: "/ws/bt_pairing")
        
        try await webSocketTask.send(.data(JSONEncoder().encode(BleCommand.advertise)))
        
        let advertisementResponse = try await webSocketTask.receive()
        
        let decodedResponse: BleSuccessResponse
        
        switch advertisementResponse {
        case .data(let data):
            decodedResponse = try JSONDecoder().decode(BleSuccessResponse.self, from: data)
        case .string(let string):
            decodedResponse = try JSONDecoder().decode(BleSuccessResponse.self, from: Data(string.utf8))
        @unknown default:
            webSocketTask.cancel(with: .internalServerError, reason: nil)
            throw HubConnectionError.invalidServerResponse
        }
        
        webSocketTask.cancel(with: .normalClosure, reason: nil)
        return decodedResponse
    }*/
}
