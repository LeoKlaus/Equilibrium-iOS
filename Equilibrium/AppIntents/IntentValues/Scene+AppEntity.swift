//
//  Scene+AppEntity.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import AppIntents
import EquilibriumAPI

extension Scene: @retroactive AppEntity {
    public static let defaultQuery: SceneQuery = SceneQuery()
    
    // Visual representation e.g. in the dropdown, when selecting the entity.
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(self.name ?? "Untitled Scene")", subtitle: "\(.init(spacedStrings: self.devices?.map(\.name) ?? []))")
    }
    
    // Placeholder whenever it needs to present your entity’s type onscreen.
    public static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Command")
    
    public struct SceneQuery: EntityQuery {
        
        @IntentParameterDependency<StartSceneIntent>(
            \.$hub
        )
        var startSceneIntent
        
        private func getApiHandler() throws -> EquilibriumAPIHandler {
            guard let hub = self.startSceneIntent?.hub else {
                throw EntityError.noHubSelected
            }
            
            return try EquilibriumAPIHandler(service: hub)
        }
        
        public init () { }
        
        public nonisolated func defaultResult() async throws -> Scene? {
            let apiHandler = try await self.getApiHandler()
            
            let scenes: [Scene] = try await apiHandler.get(endpoint: .scenes)
            
            return scenes.first
        }
        
        // Provide the list of options you want to show the user, when they select the Entity in the shortcut. You probably want to show all items you have from your array.
        public nonisolated func suggestedEntities() async throws -> [Scene] {
            let apiHandler = try await self.getApiHandler()
            
            let scenes: [Scene] = try await apiHandler.get(endpoint: .scenes)
            
            return scenes
        }
        
        // Find Entity by id to bridge the Shortcuts Entity to your App
        public nonisolated func entities(for identifiers: [Int?]) async throws -> [Scene] {
            let apiHandler = try await self.getApiHandler()
            
            let scenes: [Scene] = try await apiHandler.get(endpoint: .scenes)
            
            return scenes.filter { identifiers.contains($0.id) }
        }
    }
}
