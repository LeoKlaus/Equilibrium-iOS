//
//  DiscoveredService.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import Foundation

nonisolated struct DiscoveredService: Identifiable, Codable, Equatable, Sendable {
    var id: String {
        self.name + self.host + String(self.port)
    }
    
    let name: String
    let host: String
    let port: Int
    
    init(name: String, host: String, port: Int = 8000) {
        self.name = name
        self.host = host
        self.port = port
    }
    
    init?(rawValue: String) {
        guard let value = try? JSONDecoder().decode(Self.self, from: Data(rawValue.utf8)) else {
            return nil
        }
        self = value
    }
}
