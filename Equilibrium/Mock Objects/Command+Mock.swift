//
//  Command+Mock.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import EquilibriumAPI

extension Command {
    static let mockPowerToggle = Command(
        id: 1,
        name: "Power Toggle",
        button: .powerToggle,
        type: .ir,
        commandGroup: .power,
        device: Device(
            id: 1,
            name: "Hisense TV",
            manufacturer: "Hisense",
            model: "55U8KQ",
            type: .display,
            image: .mock,
            imageId: 1,
            commands: [],
            scenes: [],
            macros: []
        )
    )
}
