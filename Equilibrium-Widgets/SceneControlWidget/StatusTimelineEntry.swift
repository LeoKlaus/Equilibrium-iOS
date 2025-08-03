//
//  StatusTimelineEntry.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import WidgetKit
import EquilibriumAPI

struct StatusTimelineEntry: TimelineEntry {
    let date: Date
    let configuration: SelectScenesIntent
    let hub: DiscoveredService?
    let scenes: [Scene]
    let showControls: Bool
    let status: StatusReport?
    let error: String?
    
    func getWidgetURL() -> URL? {
        if let currentSceneId = status?.currentScene?.id {
            return .init(string: "equilibrium://scene/\(currentSceneId)")
        }
        return nil
    }
}
