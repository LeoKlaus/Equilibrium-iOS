//
//  EquilibriumAPIHandler+Mock.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import Foundation
import EquilibriumAPI
import UIKit

class MockApiHandler: EquilibriumAPIHandler {
    
    init() {
        try! super.init(host: "localhost", port: 80)
    }

    nonisolated override init(host: String, port: Int) throws {
        try super.init(host: "localhost", port: 80)
    }
    
    override func get(endpoint: ApiEndpoint) async throws -> Data {
        switch endpoint {
        case .commands:
            return try JSONEncoder().encode([
                Command.mockPowerToggle,
                .mockUp,
                .mockDown,
                .mockLeft,
                .mockRight,
                .mockSelect,
                .mockBack,
                .mockHDMIOne
            ])
        case .command(_):
            throw URLError(.badURL)
        case .sendCommand(_):
            throw URLError(.badURL)
        case .devices:
            return try JSONEncoder().encode([Device.mockTV, Device.mockAmplifier, .mockPlayer])
        case .device(_):
            throw URLError(.badURL)
        case .bluetoothDevices:
            return try JSONEncoder().encode([BleDevice.mock])
        case .bluetoothStartAdvert:
            throw URLError(.badURL)
        case .bluetoothStartPairing:
            throw URLError(.badURL)
        case .bluetoothConnect(_):
            throw URLError(.badURL)
        case .bluetoothDisconnect:
            throw URLError(.badURL)
        case .images:
            return try JSONEncoder().encode([UserImage.mock])
        case .image(let id):
            guard let img = UIImage(named: String(id)) else {
                throw URLError(.cannotDecodeRawData)
            }
            guard let data = img.pngData() else {
                throw URLError(.cannotDecodeContentData)
            }
            return data
        case .macros:
            return try JSONEncoder().encode([Macro.mock, .mockStart, .mockStop])
        case .macro(_):
            throw URLError(.badURL)
        case .scenes:
            return try JSONEncoder().encode([Scene.mock])
        case .scene(_):
            throw URLError(.badURL)
        case .startScene(_):
            try await Task.sleep(for: .seconds(0.5))
            return Data("Scene started...".utf8)
        case .setCurrentScene(_):
            throw URLError(.badURL)
        case .getKeymapSuggestion(_):
            throw URLError(.badURL)
        case .stopCurrentScene:
            throw URLError(.badURL)
        case .info:
            throw URLError(.badURL)
        case .systemStatus:
            throw URLError(.badURL)
        case .wsStatus:
            throw URLError(.badURL)
        case .wsCommands:
            throw URLError(.badURL)
        case .wsBtPairing:
            throw URLError(.badURL)
        case .wsKeyboard:
            throw URLError(.badURL)
        }
    }
    
    override func post(endpoint: ApiEndpoint) async throws {
        throw URLError(.notConnectedToInternet)
    }
    
    override func post<T>(endpoint: ApiEndpoint, object: T) async throws -> T where T : Decodable, T : Encodable {
        throw URLError(.notConnectedToInternet)
    }
    
    override func postMultipartForm<T>(endpoint: ApiEndpoint, fileURL: URL) async throws -> T where T : Decodable {
        throw URLError(.notConnectedToInternet)
    }
    
    override func patch<T>(endpoint: ApiEndpoint, object: T) async throws -> T where T : Decodable, T : Encodable {
        throw URLError(.notConnectedToInternet)
    }
    
    override func delete(endpoint: ApiEndpoint) async throws {
        throw URLError(.notConnectedToInternet)
    }
    
    nonisolated override func openWebsocket(endpoint: ApiEndpoint) throws -> URLSessionWebSocketTask {
        throw URLError(.notConnectedToInternet)
    }
}
