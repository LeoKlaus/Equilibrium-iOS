//
//  StartSceneIntent.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import AppIntents
import EquilibriumAPI

struct StartSceneIntent: AppIntent {
    static let title: LocalizedStringResource = "Start the selected scene via the selected hub."
    static let description: IntentDescription? = "Starts the given scene via the given hub."
    
    @Parameter(title: "Hub")
    var hub: DiscoveredService
    
    @Parameter(title: "Scene")
    var scene: Scene
    
    func perform() async throws -> some IntentResult {
        let apiHandler = try EquilibriumAPIHandler(service: hub)
        
        guard let sceneId = self.scene.id else {
            return .result()
        }
        
        try await apiHandler.post(endpoint: .startScene(id: sceneId))
        
        return .result()
    }
}
