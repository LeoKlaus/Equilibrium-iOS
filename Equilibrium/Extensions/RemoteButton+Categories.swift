//
//  RemoteButton+Categories.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import EquilibriumAPI
import SwiftUI

/*enum ButtonCategory: LocalizedStringKey, CaseIterable {
    case power = "Power"
    case volume = "Volume"
    case navigation = "Navigation"
    case transport = "Transport"
    case coloredButtons = "Colored buttons"
    case numbers = "Numbers"
    case other = "Other"*/

extension CommandGroupType: @retroactive CaseIterable {
    public static var allCases: [CommandGroupType] {
        [
            .power,
            .volume,
            .navigation,
            .transport,
            .channel,
            .numeric,
            .coloredButtons,
            .other
        ]
    }
    
    
    var localizedName: LocalizedStringKey {
        switch self {
        case .power:
            "Power"
        case .volume:
            "Volume"
        case .navigation:
            "Navigation"
        case .transport:
            "Transport"
        case .coloredButtons:
            "Colored buttons"
        case .channel:
            "Channel"
        case .numeric:
            "Numbers"
        case .other:
            "Other"
        }
    }
    
    var associatedButtons: [RemoteButton] {
        switch self {
        case .power:
            [.powerToggle, .powerOn, .powerOff]
        case .volume:
            [.volumeUp, .volumeDown, .mute]
        case .navigation:
            [
                .directionUp,
                .directionDown,
                .directionLeft,
                .directionRight,
                .select,
                .back,
                .menu,
                .exit,
                .guide
            ]
        case .transport:
            [
                .playpause,
                .play,
                .pause,
                .stop,
                .fastForward,
                .rewind,
                .nextTrack,
                .previousTrack,
                .record
            ]
        case .coloredButtons:
            [.green, .red, .blue, .yellow]
        case .numeric:
            [
                .numberZero,
                .numberOne,
                .numberTwo,
                .numberThree,
                .numberFour,
                .numberFive,
                .numberSix,
                .numberSeven,
                .numberEight,
                .numberNine
            ]
        case .other:
            [
                .brightnessUp,
                .brightnessDown,
                .turnOn,
                .turnOff,
                .other
            ]
        case .channel:
            [
                .channelUp,
                .channelDown
            ]
        }
    }
    
    var represenation: ButtonCategoryRepresentation {
        ButtonCategoryRepresentation(name: self.localizedName, buttons: self.associatedButtons)
    }
}

struct ButtonCategoryRepresentation: Identifiable {
    let id = UUID()
    let name: LocalizedStringKey
    let buttons: [ButtonRepresentation]
    
    init(name: LocalizedStringKey, buttons: [RemoteButton]) {
        self.name = name
        self.buttons = buttons.map(\.buttonRepresentation)
    }
}

struct ButtonRepresentation: Identifiable {
    var id: RemoteButton {
        self.button
    }
    let name: LocalizedStringKey
    let systemImage: String
    let button: RemoteButton
}

extension RemoteButton {
    static var allButtons: [ButtonCategoryRepresentation] {
        return CommandGroupType.allCases.map(\.represenation)
    }
    
    static func allButtons(for category: CommandGroupType) -> ButtonCategoryRepresentation {
        ButtonCategoryRepresentation(name: category.localizedName, buttons: category.associatedButtons)
    }
    
    var buttonRepresentation: ButtonRepresentation {
        switch self {
        case .powerToggle:
            ButtonRepresentation(name: "Power toggle", systemImage: "power", button: self)
        case .powerOff:
            ButtonRepresentation(name: "Power off", systemImage: "poweroff", button: self)
        case .powerOn:
            ButtonRepresentation(name: "Power on", systemImage: "poweron", button: self)
        case .volumeUp:
            ButtonRepresentation(name: "Volume up", systemImage: "speaker.plus", button: self)
        case .volumeDown:
            ButtonRepresentation(name: "Volume down", systemImage: "speaker.minus", button: self)
        case .mute:
            ButtonRepresentation(name: "Mute", systemImage: "speaker.slash", button: self)
        case .directionUp:
            ButtonRepresentation(name: "Up", systemImage: "dpad.up.fill", button: self)
        case .directionDown:
            ButtonRepresentation(name: "Down", systemImage: "dpad.down.fill", button: self)
        case .directionLeft:
            ButtonRepresentation(name: "Left", systemImage: "dpad.left.fill", button: self)
        case .directionRight:
            ButtonRepresentation(name: "Right", systemImage: "dpad.right.fill", button: self)
        case .select:
            ButtonRepresentation(name: "Select", systemImage: "x.circle", button: self)
        case .guide:
            ButtonRepresentation(name: "Guide", systemImage: "info.bubble", button: self)
        case .back:
            ButtonRepresentation(name: "Back", systemImage: "arrowshape.turn.up.backward", button: self)
        case .menu:
            ButtonRepresentation(name: "Menu", systemImage: "filemenu.and.selection", button: self)
        case .exit:
            ButtonRepresentation(name: "Exit", systemImage: "delete.backward", button: self)
        case .play:
            ButtonRepresentation(name: "Play", systemImage: "play", button: self)
        case .pause:
            ButtonRepresentation(name: "Pause", systemImage: "pause", button: self)
        case .playpause:
            ButtonRepresentation(name: "Play/Pause", systemImage: "playpause", button: self)
        case .stop:
            ButtonRepresentation(name: "Stop", systemImage: "stop", button: self)
        case .fastForward:
            ButtonRepresentation(name: "Fast Forward", systemImage: "forward", button: self)
        case .rewind:
            ButtonRepresentation(name: "Rewind", systemImage: "backward", button: self)
        case .nextTrack:
            ButtonRepresentation(name: "Next Track", systemImage: "forward.end", button: self)
        case .previousTrack:
            ButtonRepresentation(name: "Previous Track", systemImage: "backward.end", button: self)
        case .record:
            ButtonRepresentation(name: "Record", systemImage: "record.circle", button: self)
        case .green:
            ButtonRepresentation(name: "Green", systemImage: "g.circle", button: self)
        case .red:
            ButtonRepresentation(name: "Red", systemImage: "r.circle", button: self)
        case .blue:
            ButtonRepresentation(name: "Blue", systemImage: "b.circle", button: self)
        case .yellow:
            ButtonRepresentation(name: "Yellow", systemImage: "y.circle", button: self)
        case .numberZero:
            ButtonRepresentation(name: "0", systemImage: "0.square", button: self)
        case .numberOne:
            ButtonRepresentation(name: "1", systemImage: "1.square", button: self)
        case .numberTwo:
            ButtonRepresentation(name: "2", systemImage: "2.square", button: self)
        case .numberThree:
            ButtonRepresentation(name: "3", systemImage: "3.square", button: self)
        case .numberFour:
            ButtonRepresentation(name: "4", systemImage: "4.square", button: self)
        case .numberFive:
            ButtonRepresentation(name: "5", systemImage: "5.square", button: self)
        case .numberSix:
            ButtonRepresentation(name: "6", systemImage: "6.square", button: self)
        case .numberSeven:
            ButtonRepresentation(name: "7", systemImage: "7.square", button: self)
        case .numberEight:
            ButtonRepresentation(name: "8", systemImage: "8.square", button: self)
        case .numberNine:
            ButtonRepresentation(name: "9", systemImage: "9.square", button: self)
        case .channelUp:
            ButtonRepresentation(name: "Channel Up", systemImage: "chevron.up.square", button: self)
        case .channelDown:
            ButtonRepresentation(name: "Channel Down", systemImage: "chevron.down.square", button: self)
        case .brightnessUp:
            ButtonRepresentation(name: "Brightness Up", systemImage: "sun.max.fill", button: self)
        case .brightnessDown:
            ButtonRepresentation(name: "Brightness Down", systemImage: "sun.min", button: self)
        case .turnOn:
            ButtonRepresentation(name: "Turn On", systemImage: "poweron", button: self)
        case .turnOff:
            ButtonRepresentation(name: "Turn Off", systemImage: "poweroff", button: self)
        case .other:
            ButtonRepresentation(name: "Other", systemImage: "ellipsis", button: self)
         }
    }
}
