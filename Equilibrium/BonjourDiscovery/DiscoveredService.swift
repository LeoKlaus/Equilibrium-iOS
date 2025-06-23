//
//  DiscoveredService.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

//import Network

struct DiscoveredService: Identifiable, Codable {
    var id: String {
        self.name
    }
    
    let name: String
    let host: String
    let port: Int
}
