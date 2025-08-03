//
//  StatusProvider.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import WidgetKit
import EquilibriumAPI

struct StatusProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> StatusTimelineEntry {
        StatusTimelineEntry(
            date: .now,
            configuration: SelectScenesIntent(),
            hub: DiscoveredService(name: "My Hub", host: "http://10.0.0.10"),
            scenes: [
                Scene(name: "Watch TV"),
                Scene(name: "Play PS5")
            ],
            showControls: true,
            status: StatusReport(
                current_scene: nil,
                scene_status: nil,
                devices: nil
            ),
            error: nil
        )
    }
    
    private func getCurrentStatus(hub: DiscoveredService) async throws -> StatusReport {
        let apiHandler = try EquilibriumAPIHandler(service: hub)
        return try await apiHandler.get(endpoint: .systemStatus)
    }
    
    func snapshot(for configuration: SelectScenesIntent, in context: Context) async -> StatusTimelineEntry {
        guard let hub = configuration.hub else {
            return StatusTimelineEntry(
                date: .now,
                configuration: configuration,
                hub: nil,
                scenes: configuration.scenes,
                showControls: configuration.showControls,
                status: nil,
                error: "Couldn't get hub, make sure to select a hub in the widget configuration (long press widget)."
            )
        }
        
        do {
            let status = try await self.getCurrentStatus(hub: hub)
            
            return StatusTimelineEntry(
                date: .now,
                configuration: configuration,
                hub: configuration.hub,
                scenes: configuration.scenes,
                showControls: configuration.showControls,
                status: status,
                error: nil
            )
        } catch {
            return StatusTimelineEntry(
                date: .now,
                configuration: configuration,
                hub: nil,
                scenes: configuration.scenes,
                showControls: configuration.showControls,
                status: nil,
                error: error.localizedDescription
            )
        }
    }
    
    func timeline(for configuration: SelectScenesIntent, in context: Context) async -> Timeline<StatusTimelineEntry> {
        
        let entry = await self.snapshot(for: configuration, in: context)
        
        return Timeline(
            entries: [entry],
            policy: .after(.now.addingTimeInterval(15 * 60))
        )
    }
}
