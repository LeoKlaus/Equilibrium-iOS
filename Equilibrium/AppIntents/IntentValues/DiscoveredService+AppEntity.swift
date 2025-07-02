//
//  DiscoveredService+AppEntity.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 02.07.25.
//

import AppIntents

extension DiscoveredService: AppEntity {
    
    static let defaultQuery: HubQuery = HubQuery()
    
    // Visual representation e.g. in the dropdown, when selecting the entity.
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(self.name)")
    }
    
    // Placeholder whenever it needs to present your entity’s type onscreen.
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Hub"
    
    struct HubQuery: EntityQuery {
        
        nonisolated init () { }
        
        nonisolated func defaultResult() async -> DiscoveredService? {
            guard let userDefaults = await UserDefaults(suiteName: .userDefaultGroup) else {
                return nil
            }
            
            if let activeHubStr = userDefaults.string(forKey: UserDefaultKey.currentHub.rawValue), let activeHub = DiscoveredService(rawValue: activeHubStr) {
                return activeHub
            } else if let connectedHubsStr = userDefaults.string(forKey: UserDefaultKey.connectedHubs.rawValue), let connectedHubs: [DiscoveredService] = await Array(rawValue: connectedHubsStr) {
                return connectedHubs.first
            }
            
            return nil
        }
        
        // Provide the list of options you want to show the user, when they select the Entity in the shortcut. You probably want to show all items you have from your array.
        nonisolated func suggestedEntities() async throws -> [DiscoveredService] {
            guard let userDefaults = await UserDefaults(suiteName: .userDefaultGroup) else {
                return []
            }
            if let connectedHubsStr = userDefaults.string(forKey: UserDefaultKey.connectedHubs.rawValue), let connectedHubs: [DiscoveredService] = await Array(rawValue: connectedHubsStr) {
                return connectedHubs
            }
            return []
        }
        
        // Find Entity by id to bridge the Shortcuts Entity to your App
        nonisolated func entities(for identifiers: [String]) async throws -> [DiscoveredService] {
            guard let userDefaults = await UserDefaults(suiteName: .userDefaultGroup) else {
                return []
            }
            if let connectedHubsStr = userDefaults.string(forKey: UserDefaultKey.connectedHubs.rawValue), let connectedHubs: [DiscoveredService] = await Array(rawValue: connectedHubsStr) {
                return connectedHubs.filter{ identifiers.contains($0.id) }
            }
            return []
        }
    }
}
