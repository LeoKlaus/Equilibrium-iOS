//
//  SceneControlWidget.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct SceneControlWidget: Widget {
    let kind: String = "EquilibriumWidgets"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: SelectScenesIntent.self,
            provider: StatusProvider()) { entry in
                SceneWidgetEntryView(entry: entry)
                    .containerBackground(.background, for: .widget)
                    .widgetURL(entry.getWidgetURL())
            }
            .promptsForUserConfigurationIfPossible()
            .configurationDisplayName("Activity Controls")
            .description("Control which activity is running on your hub.")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge, .accessoryRectangular])
    }
}


#Preview("Small", as: .systemSmall) {
    SceneControlWidget()
} timeline: {
    // Normal states
    StatusTimelineEntry.mockNoActiveScene
    StatusTimelineEntry.mockActiveScene
    // Error states
    StatusTimelineEntry.mockError
}

#Preview("Medium", as: .systemMedium) {
    SceneControlWidget()
} timeline: {
    // Normal states
    StatusTimelineEntry.mockNoActiveScene
    StatusTimelineEntry.mockActiveScene
    // Error states
    StatusTimelineEntry.mockError
}

#Preview("Accessory Rectangular", as: .accessoryRectangular) {
    SceneControlWidget()
} timeline: {
    // Normal states
    StatusTimelineEntry.mockNoActiveScene
    StatusTimelineEntry.mockActiveScene
    // Error states
    StatusTimelineEntry.mockError
}
