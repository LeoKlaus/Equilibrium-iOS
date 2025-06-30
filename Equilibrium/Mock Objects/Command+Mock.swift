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
    
    static let mockUp = Command(name: "Up", button: .directionUp, type: .ir, commandGroup: .navigation)
    static let mockDown = Command(name: "Down", button: .directionDown, type: .ir, commandGroup: .navigation)
    static let mockLeft = Command(name: "Left", button: .directionLeft, type: .ir, commandGroup: .navigation)
    static let mockRight = Command(name: "Right", button: .directionRight, type: .ir, commandGroup: .navigation)
    static let mockSelect = Command(name: "Ok", button: .select, type: .ir, commandGroup: .navigation)
    static let mockBack = Command(name: "Back", button: .back, type: .ir, commandGroup: .navigation)
    static let mockMenu = Command(name: "Menu", button: .menu, type: .ir, commandGroup: .navigation)
    static let mockExit = Command(name: "Exit", button: .exit, type: .ir, commandGroup: .navigation)
    static let mockGuide = Command(name: "Info", button: .guide, type: .ir, commandGroup: .navigation)
    
    
    static let mockVolumeUp = Command(name: "Volume Up", button: .volumeUp, type: .ir, commandGroup: .volume)
    static let mockVolumeDown = Command(name: "Volume Down", button: .volumeDown, type: .ir, commandGroup: .volume)
    static let mockMute = Command(name: "Mute", button: .mute, type: .ir, commandGroup: .volume)
    
    
    static let mockChannelUp = Command(name: "Channel Up", button: .channelUp, type: .ir, commandGroup: .channel)
    static let mockChannelDown = Command(name: "Channel Down", button: .channelDown, type: .ir, commandGroup: .channel)
}
