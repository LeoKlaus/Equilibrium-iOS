//
//  StopSceneIntent.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import AppIntents
import EquilibriumAPI

struct StopSceneIntent: AppIntent {
    static let title: LocalizedStringResource = "Stop the current scene on the selected hub."
    static let description: IntentDescription? = "Stops the current scene on the given hub."
    
    @Parameter(title: "Hub")
    var hub: DiscoveredService
    
    func perform() async throws -> some IntentResult {
        let apiHandler = try EquilibriumAPIHandler(service: hub)
        
        try await apiHandler.post(endpoint: .stopCurrentScene)
        
        return .result()
    }
}
