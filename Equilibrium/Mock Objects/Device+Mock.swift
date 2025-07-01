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
            .mockPowerToggle,
            .mockLiveTV,
            .mockHDMIOne,
            .mockHDMITwo,
            .mockHDMIThree,
            .mockComposite,
            .mockOne,
            .mockTwo,
            .mockThree,
            .mockFour,
            .mockFive,
            .mockSix,
            .mockSeven,
            .mockEight,
            .mockNine,
            .mockZero
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
            .mockChannelDown,
            //.mockPlayPause,
            .mockPlay,
            .mockPause,
            .mockStop,
            .mockFastForward,
            .mockRewind,
            .mockNextTrack,
            .mockPreviousTrack,
            .mockRecord,
            .mockBlue,
            .mockYellow,
            .mockRed,
            .mockGreen,
            .mockOne,
            .mockTwo,
            .mockThree,
            .mockFour,
            .mockFive,
            .mockSix,
            .mockSeven,
            .mockEight,
            .mockNine,
            .mockZero,
            .mockOther
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
            .mockMute,
            .mockHDMIOne,
            .mockHDMITwo,
            .mockHDMIThree,
            .mockComposite,
        ],
        scenes: [],
        macros: []
    )
}
