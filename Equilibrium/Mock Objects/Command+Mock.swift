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
        commandGroupId: 1
    )
}
