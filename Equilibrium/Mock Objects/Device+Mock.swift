//
//  Device+Mock.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import EquilibriumAPI

extension Device {
    static let mockTV = Device(
        id: 1,
        name: "Hisense TV",
        manufacturer: "Hisense",
        model: "55U8KQ",
        type: .display,
        image: .mock,
        imageId: 1,
        commands: [
            .mockPowerToggle
        ],
        scenes: [],
        macros: []
    )
    
    static let mockPlayer = Device(
        id: 2,
        name: "Apple TV",
        manufacturer: "Apple",
        model: "Apple TV 4K",
        type: .player,
        commands: [
            .mockPowerToggle,
            .mockUp,
            .mockDown,
            .mockLeft,
            .mockRight,
            .mockSelect,
            .mockBack,
            .mockMenu,
            .mockExit,
            .mockGuide,
            .mockChannelUp,
            .mockChannelDown
        ],
        scenes: [],
        macros: []
    )
    
    static let mockAmplifier = Device(
        id: 3,
        name: "Denon Amplifier",
        manufacturer: "Denon",
        model: "AVR-X2800H",
        type: .amplifier,
        commands: [
            .mockPowerToggle,
            .mockVolumeUp,
            .mockVolumeDown,
            .mockMute
        ],
        scenes: [],
        macros: []
    )
}
