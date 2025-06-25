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
    
    override func get(path: String) async throws -> Data {
        switch path {
        case "/devices", "/devices/":
            return try JSONEncoder().encode([Device.mockTV, Device.mockAmplifier])
        case "/devices/ble_devices":
            return try JSONEncoder().encode([BleDevice.mock])
        case "/commands", "/commands/":
            return try JSONEncoder().encode([Command.mockPowerToggle])
        case "/images", "/images/":
            return try JSONEncoder().encode([UserImage.mock])
        case "/images/1", "/images/1/":
            guard let img = UIImage(named: "1") else {
                throw URLError(.cannotDecodeRawData)
            }
            guard let data = img.pngData() else {
                throw URLError(.cannotDecodeContentData)
            }
            return data
        default:
            throw URLError(.badURL)
        }
    }
    
    override func post(path: String) async throws {
        throw URLError(.notConnectedToInternet)
    }
    
    override func post<T>(path: String, object: T) async throws -> T where T : Decodable, T : Encodable {
        throw URLError(.notConnectedToInternet)
    }
    
    override func postMultipartForm<T>(path: String, fileURL: URL) async throws -> T where T : Decodable {
        throw URLError(.notConnectedToInternet)
    }
    
    override func patch<T>(path: String, object: T) async throws -> T where T : Decodable, T : Encodable {
        throw URLError(.notConnectedToInternet)
    }
    
    override func delete(path: String) async throws {
        throw URLError(.notConnectedToInternet)
    }
    
    nonisolated override func openWebsocket(path: String) throws -> URLSessionWebSocketTask {
        throw URLError(.notConnectedToInternet)
    }
}
