//
//  StatusTimelineEntry+Mock.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import Foundation
import EquilibriumAPI

extension StatusTimelineEntry {
    static let mockNoActiveScene = StatusTimelineEntry(
        date: .now,
        configuration: SelectScenesIntent(),
        hub: .mock,
        scenes: [
            .mock,
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
    
    static let mockActiveScene = StatusTimelineEntry(
        date: .now,
        configuration: SelectScenesIntent(),
        hub: .mock,
        scenes: [
            .mock,
            Scene(name: "Play PS5")
        ],
        showControls: true,
        status: StatusReport(
            current_scene: .mock,
            scene_status: .active,
            devices: nil
        ),
        error: nil
    )
    
    static let mockError = StatusTimelineEntry(
        date: .now,
        configuration: SelectScenesIntent(),
        hub: .mock,
        scenes: [
            .mock,
            Scene(name: "Play PS5")
        ],
        showControls: true,
        status: nil,
        error: "Couldn't connect to server"
    )
}
