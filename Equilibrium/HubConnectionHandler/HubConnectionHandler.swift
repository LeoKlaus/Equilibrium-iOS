//
//  HubConnectionHandler.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import Foundation
import EquilibriumAPI
import OSLog
import EasyErrorHandling

@Observable
class HubConnectionHandler {
    
    static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: ZeroconfBrowser.self)
    )
    
    var apiHandler: EquilibriumAPIHandler?
    
    var currentSceneStatus: SceneStatusReport?
    
    var scenes: [Scene] = []
    
    var devices: [Device] = []
    
    var socketStream: SocketStream?
    
    init() {
        if let userDefaults = UserDefaults(suiteName: "group.me.wehrfritz.Equilibrium"),
           let currentHubData = userDefaults.data(forKey: "currentHub"),
           let service = try? JSONDecoder().decode(DiscoveredService.self, from: currentHubData),
           let apiHandler = try? EquilibriumAPIHandler(service: service) {
            self.apiHandler = apiHandler
        }
    }
    
    func switchToHub(_ service: DiscoveredService) throws {
        self.apiHandler = try EquilibriumAPIHandler(service: service)
        guard let userDefaults = UserDefaults(suiteName: "group.me.wehrfritz.Equilibrium") else {
            throw HubConnectionError.couldntGetUserdefaults
        }
        userDefaults.set(try JSONEncoder().encode(service), forKey: "currentHub")
    }
    
    func getDevices() async throws -> [Device] {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(path: "/devices/")
    }
}
