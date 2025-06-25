//
//  EquilibriumAPIHandler+Init.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import EquilibriumAPI

extension EquilibriumAPIHandler {
    convenience init(service: DiscoveredService) throws {
        try self.init(host: service.host, port: service.port)
    }
}
