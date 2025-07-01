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
    
    static let mockUp = Command(id: 2, name: "Up", button: .directionUp, type: .ir, commandGroup: .navigation)
    static let mockDown = Command(id: 3, name: "Down", button: .directionDown, type: .ir, commandGroup: .navigation)
    static let mockLeft = Command(id: 4, name: "Left", button: .directionLeft, type: .ir, commandGroup: .navigation)
    static let mockRight = Command(id: 5, name: "Right", button: .directionRight, type: .ir, commandGroup: .navigation)
    static let mockSelect = Command(id: 6, name: "Ok", button: .select, type: .ir, commandGroup: .navigation)
    static let mockBack = Command(id: 7, name: "Back", button: .back, type: .ir, commandGroup: .navigation)
    static let mockMenu = Command(id: 8, name: "Menu", button: .menu, type: .ir, commandGroup: .navigation)
    static let mockExit = Command(id: 9, name: "Exit", button: .exit, type: .ir, commandGroup: .navigation)
    static let mockGuide = Command(id: 10, name: "Info", button: .guide, type: .ir, commandGroup: .navigation)
    
    
    static let mockVolumeUp = Command(id: 11, name: "Volume Up", button: .volumeUp, type: .ir, commandGroup: .volume)
    static let mockVolumeDown = Command(id: 12, name: "Volume Down", button: .volumeDown, type: .ir, commandGroup: .volume)
    static let mockMute = Command(id: 13, name: "Mute", button: .mute, type: .ir, commandGroup: .volume)
    
    
    static let mockChannelUp = Command(id: 14, name: "Channel Up", button: .channelUp, type: .ir, commandGroup: .channel)
    static let mockChannelDown = Command(id: 15, name: "Channel Down", button: .channelDown, type: .ir, commandGroup: .channel)
    
    static let mockPlayPause = Command(id: 16, name: "Play/Pause", button: .playpause, type: .ir, commandGroup: .transport)
    static let mockPlay = Command(id: 17, name: "Play", button: .play, type: .ir, commandGroup: .transport)
    static let mockPause = Command(id: 18, name: "Pause", button: .pause, type: .ir, commandGroup: .transport)
    static let mockStop = Command(id: 19, name: "Stop", button: .stop, type: .ir, commandGroup: .transport)
    static let mockFastForward = Command(id: 20, name: "Fast Forward", button: .fastForward, type: .ir, commandGroup: .transport)
    static let mockRewind = Command(id: 21, name: "Rewind", button: .rewind, type: .ir, commandGroup: .transport)
    static let mockNextTrack = Command(id: 22, name: "Next Track", button: .nextTrack, type: .ir, commandGroup: .transport)
    static let mockPreviousTrack = Command(id: 23, name: "Previous Track", button: .previousTrack, type: .ir, commandGroup: .transport)
    static let mockRecord = Command(id: 24, name: "Record", button: .record, type: .ir, commandGroup: .transport)
    
    
    static let mockRed = Command(id: 25, name: "Red", button: .red, type: .ir, commandGroup: .coloredButtons)
    static let mockGreen = Command(id: 26, name: "Green", button: .green, type: .ir, commandGroup: .coloredButtons)
    static let mockBlue = Command(id: 27, name: "Blue", button: .blue, type: .ir, commandGroup: .coloredButtons)
    static let mockYellow = Command(id: 28, name: "Yellow", button: .yellow, type: .ir, commandGroup: .coloredButtons)
    
    
    static let mockHDMIOne = Command(id: 29, name: "HDMI 1", button: .other, type: .ir, commandGroup: .input)
    static let mockHDMITwo = Command(id: 30, name: "HDMI 2", button: .other, type: .ir, commandGroup: .input)
    static let mockHDMIThree = Command(id: 31, name: "HDMI 3", button: .other, type: .ir, commandGroup: .input)
    static let mockComposite = Command(id: 32, name: "Composite", button: .other, type: .ir, commandGroup: .input)
    static let mockLiveTV = Command(id: 33, name: "Live TV", button: .other, type: .ir, commandGroup: .input)
    
    
    static let mockOne = Command(id: 34, name: "1", button: .numberOne, type: .ir, commandGroup: .numeric)
    static let mockTwo = Command(id: 35, name: "2", button: .numberTwo, type: .ir, commandGroup: .numeric)
    static let mockThree = Command(id: 36, name: "3", button: .numberThree, type: .ir, commandGroup: .numeric)
    static let mockFour = Command(id: 37, name: "4", button: .numberFour, type: .ir, commandGroup: .numeric)
    static let mockFive = Command(id: 38, name: "5", button: .numberFive, type: .ir, commandGroup: .numeric)
    static let mockSix = Command(id: 39, name: "6", button: .numberSix, type: .ir, commandGroup: .numeric)
    static let mockSeven = Command(id: 40, name: "7", button: .numberSeven, type: .ir, commandGroup: .numeric)
    static let mockEight = Command(id: 41, name: "8", button: .numberEight, type: .ir, commandGroup: .numeric)
    static let mockNine = Command(id: 42, name: "9", button: .numberNine, type: .ir, commandGroup: .numeric)
    static let mockZero = Command(id: 43, name: "0", button: .numberZero, type: .ir, commandGroup: .numeric)
    
    
    static let mockOther = Command(id: 44, name: "Test Command", button: .other, type: .ir, commandGroup: .other)
}
