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
    
    var currentSceneStatus: StatusReport?
    
    var scenes: [Scene] = []
    
    var devices: [Device] = []
    
    var socketStream: SocketStream?
    
    init() {
        if let userDefaults = UserDefaults(suiteName: "group.me.wehrfritz.Equilibrium"),
           let currentHubString = userDefaults.string(forKey: UserDefaultKey.currentHub.rawValue),
           let service = try? JSONDecoder().decode(DiscoveredService.self, from: Data(currentHubString.utf8)),
           let apiHandler = try? EquilibriumAPIHandler(service: service) {
            self.apiHandler = apiHandler
        }
    }
    
    func switchToHub(_ service: DiscoveredService) throws {
        self.apiHandler = try EquilibriumAPIHandler(service: service)
        guard let userDefaults = UserDefaults(suiteName: "group.me.wehrfritz.Equilibrium") else {
            throw HubConnectionError.couldntGetUserdefaults
        }
        let data = try JSONEncoder().encode(service)
        userDefaults.set(String(data: data, encoding: .utf8), forKey: UserDefaultKey.currentHub.rawValue)
    }
}
