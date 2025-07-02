//
//  DiscoveredService.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

//import Network

struct DiscoveredService: Identifiable, Codable, Equatable {
    var id: String {
        self.name + self.host + String(self.port)
    }
    
    let name: String
    let host: String
    let port: Int
}
