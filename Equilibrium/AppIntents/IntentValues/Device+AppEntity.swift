//
//  Device+AppEntity.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import AppIntents
import EquilibriumAPI

extension Device: @retroactive AppEntity {
    public static let defaultQuery: DeviceQuery = DeviceQuery()
    
    // Visual representation e.g. in the dropdown, when selecting the entity.
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(self.name)", subtitle: "\(.init(spacedStrings: [self.manufacturer, self.model]))")
    }
    
    // Placeholder whenever it needs to present your entity’s type onscreen.
    public static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Device")
    
    public struct DeviceQuery: EntityQuery {
        
        @IntentParameterDependency<SendCommandToDeviceIntent>(
            \.$hub
        )
        var sendCommandToDeviceIntent
        
        private func getApiHandler() throws -> EquilibriumAPIHandler {
            guard let hub = self.sendCommandToDeviceIntent?.hub else {
                throw EntityError.noHubSelected
            }
            
            return try EquilibriumAPIHandler(service: hub)
        }
        
        public init () { }
        
        public nonisolated func defaultResult() async throws -> Device? {
            let apiHandler = try await self.getApiHandler()
            
            let devices: [Device] = try await apiHandler.get(endpoint: .devices)
            
            return devices.first
        }
        
        // Provide the list of options you want to show the user, when they select the Entity in the shortcut. You probably want to show all items you have from your array.
        public nonisolated func suggestedEntities() async throws -> [Device] {
            let apiHandler = try await self.getApiHandler()
            
            let devices: [Device] = try await apiHandler.get(endpoint: .devices)
            
            return devices
        }
        
        // Find Entity by id to bridge the Shortcuts Entity to your App
        public nonisolated func entities(for identifiers: [Int?]) async throws -> [Device] {
            let apiHandler = try await self.getApiHandler()
            
            let devices: [Device] = try await apiHandler.get(endpoint: .devices)
            
            return devices.compactMap { device in
                if identifiers.contains(device.id) {
                    device
                } else {
                    nil
                }
            }
        }
    }
}
