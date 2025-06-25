//
//  Scene+Mock.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import EquilibriumAPI

extension Scene {
    static let mock = Scene(
        id: 4,
        name: "Watch Apple TV",
        image: .mock,
        imageId: 1,
        bluetoothAddress: "XX:XX:XX:XX:XX:XX",
        keymap: "apple_tv",
        devices: [
            
        ],
        startMacro: .mockStart,
        stopMacro: .mockStop,
        macros: [
            .mock
        ]
    )
}
