//
//  SelectActivitiesIntent.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import AppIntents
import EquilibriumAPI

struct SelectScenesIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select scenes"
    static var description = IntentDescription("Select the scenes to display.")
    
    @Parameter(title: "Hub", default: nil)
    var hub: DiscoveredService?
    
    @Parameter(title: "Show controls for current scene", description: "If a scene is active, this widget will show common controls for that scene (like volume or channel controls).", default: true)
    var showControls: Bool
    
    @Parameter(title: "Scene", description: "Which scene to show", default: [], size: [
        .systemSmall: IntentCollectionSize(min: 0, max: 2),
        .systemMedium: IntentCollectionSize(min: 0, max: 6),
        .systemLarge: IntentCollectionSize(min: 0, max: 12),
        .systemExtraLarge: IntentCollectionSize(min: 0, max: 24),
        .accessoryInline: IntentCollectionSize(min: 0, max: 1),
        .accessoryCorner: IntentCollectionSize(min: 0, max: 1),
        .accessoryCircular: IntentCollectionSize(min: 0, max: 1),
        .accessoryRectangular: IntentCollectionSize(min: 0, max: 2)
    ])
    var scenes: [Scene]
    
    init(scenes: [Scene]) {
        self.scenes = scenes
    }
    
    init() {
    }
}
