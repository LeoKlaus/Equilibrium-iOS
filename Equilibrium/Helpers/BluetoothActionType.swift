//
//  BluetoothActionType.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import SwiftUI

enum BluetoothActionType: LocalizedStringKey, CaseIterable {
    case regularKey = "Regular Key"
    case mediaKey = "Media Key"
}

enum CommonBluetoothKey: String, CaseIterable {
    case esc = "KEY_ESC"
    case enter = "KEY_ENTER"
    case up = "KEY_UP"
    case down = "KEY_DOWN"
    case left = "KEY_LEFT"
    case right = "KEY_RIGHT"
    case other
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .esc:
            "Escape"
        case .enter:
            "Enter"
        case .up:
            "Up"
        case .down:
            "Down"
        case .left:
            "Left"
        case .right:
            "Right"
        case .other:
            "Other"
        }
    }
}

enum BluetoothMediaKey: String, CaseIterable {
    case play = "KEY_PLAY"
    case pause = "KEY_PAUSE"
    case playPause = "KEY_PLAY_PAUSE"
    case fastForward = "KEY_FAST_FORWARD"
    case rewind = "KEY_REWIND"
    case nextTrack = "KEY_NEXT_TRACK"
    case previousTrack = "KEY_PREVIOUS_TRACK"
    case stop = "KEY_STOP"
    case menu = "KEY_MENU"
    case volumeUp = "KEY_VOLUME_UP"
    case volumeDown = "KEY_VOLUME_DOWN"
    case mute = "KEY_MUTE"
    case power = "KEY_POWER"
    case sleep = "KEY_SLEEP"
    case search = "KEY_AC_SEARCH"
    case home = "KEY_AC_HOME"
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .play:
            "Play"
        case .pause:
            "Pause"
        case .playPause:
            "Play/Pause"
        case .fastForward:
            "Fast Forward"
        case .rewind:
            "Rewind"
        case .nextTrack:
            "Next Track"
        case .previousTrack:
            "Previous Track"
        case .stop:
            "Stop"
        case .menu:
            "Menu"
        case .volumeUp:
            "Volume Up"
        case .volumeDown:
            "Volume Down"
        case .mute:
            "Mute"
        case .power:
            "Power"
        case .sleep:
            "Sleep"
        case .search:
            "Search"
        case .home:
            "Home"
        }
    }
}
