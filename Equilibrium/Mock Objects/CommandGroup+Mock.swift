//
//  CommandGroup+Mock.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import EquilibriumAPI

extension CommandGroup {
    static let mock = CommandGroup(
        id: 1,
        name: "Power",
        type: .power,
        deviceId: 1,
        commands: [
            .mockPowerToggle
        ]
    )
}
