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
        commandGroups: [
            .mock
        ],
        scenes: [
        ],
        macros: []
    )
}
