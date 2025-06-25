//
//  Macro+Mock.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import EquilibriumAPI

extension Macro {
    static let mock = Macro(
        id: 1,
        name: "Switch Audio Device",
        commands: [
            
        ],
        delays: [500, 0, 250, 0],
        scenes: [
        ],
        devices: [
            .mockTV
        ]
    )
    
    static let mockStart = Macro(
        id: 2,
        name: "Start Apple TV",
        commands: [
            .mockPowerToggle
        ],
        delays: [],
        scenes: [
        ],
        devices: [
            .mockTV
        ]
    )
    
    static let mockStop = Macro(
        id: 3,
        name: "Stop Apple TV",
        commands: [
            
        ],
        delays: [],
        scenes: [
        ],
        devices: [
            .mockTV
        ]
    )
}
