//
//  Command+AppEntity.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import AppIntents
import EquilibriumAPI

extension Command: @retroactive AppEntity {
    public static let defaultQuery: CommandQuery = CommandQuery()
    
    // Visual representation e.g. in the dropdown, when selecting the entity.
    public var displayRepresentation: DisplayRepresentation {
        if let deviceName = self.device?.name {
            DisplayRepresentation(title: "\(self.name)", subtitle: "\(deviceName)", image: .init(systemName: self.button.buttonRepresentation.systemImage))
        } else {
            DisplayRepresentation(title: "\(self.name)", image: .init(systemName: self.button.buttonRepresentation.systemImage))
        }
    }
    
    // Placeholder whenever it needs to present your entity’s type onscreen.
    public static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Command")
    
    public struct CommandQuery: EntityQuery {
        
        @IntentParameterDependency<SendCommandToDeviceIntent>(
            \.$hub,
             \.$device
        )
        var sendCommandToDeviceIntent
        
        @IntentParameterDependency<SendCommandIntent>(
            \.$hub
        )
        var sendCommandIntent
        
        private var selectedDevice: Device? {
            self.sendCommandToDeviceIntent?.device
        }
        
        private func getApiHandler() throws -> EquilibriumAPIHandler {
            guard let hub = self.sendCommandIntent?.hub ?? self.sendCommandToDeviceIntent?.hub else {
                throw EntityError.noHubSelected
            }
            
            return try EquilibriumAPIHandler(service: hub)
        }
        
        private func getCommands() async throws -> [Command] {
            if let deviceCommands = selectedDevice?.commands {
                return deviceCommands
            }
            
            let apiHandler = try self.getApiHandler()
            
            let commands: [Command] = try await apiHandler.get(endpoint: .commands)
            
            return commands.filter { $0.device == nil }
        }
        
        public init () { }
        
        public nonisolated func defaultResult() async throws -> Command? {
            return try await self.getCommands().first
        }
        
        // Provide the list of options you want to show the user, when they select the Entity in the shortcut. You probably want to show all items you have from your array.
        public nonisolated func suggestedEntities() async throws -> [Command] {
            return try await self.getCommands()
        }
        
        // Find Entity by id to bridge the Shortcuts Entity to your App
        public nonisolated func entities(for identifiers: [Int?]) async throws -> [Command] {
            let commands = try await self.getCommands()
            
            return commands.filter { identifiers.contains($0.id) }
        }
    }
}
