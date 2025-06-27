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
            .input,
            .coloredButtons,
            .other
        ]
    }
    
    var localizedName: String {
        switch self {
        case .power:
            String(localized: "Power")
        case .volume:
            String(localized: "Volume")
        case .navigation:
            String(localized: "Navigation")
        case .transport:
            String(localized: "Transport")
        case .coloredButtons:
            String(localized: "Color")
        case .channel:
            String(localized: "Channel")
        case .numeric:
            String(localized: "Numbers")
        case .input:
            String(localized: "Input")
        case .other:
            String(localized: "Other")
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
        case .input:
            [
                .other
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
    let name: String
    let buttons: [ButtonRepresentation]
    
    init(name: String, buttons: [RemoteButton]) {
        self.name = name
        self.buttons = buttons.map(\.buttonRepresentation)
    }
}

struct ButtonRepresentation: Identifiable {
    var id: RemoteButton {
        self.button
    }
    let name: String
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
            ButtonRepresentation(name: String(localized: "Power toggle"), systemImage: "power", button: self)
        case .powerOff:
            ButtonRepresentation(name: String(localized: "Power off"), systemImage: "poweroff", button: self)
        case .powerOn:
            ButtonRepresentation(name: String(localized: "Power on"), systemImage: "poweron", button: self)
        case .volumeUp:
            ButtonRepresentation(name: String(localized: "Volume up"), systemImage: "speaker.plus", button: self)
        case .volumeDown:
            ButtonRepresentation(name: String(localized: "Volume down"), systemImage: "speaker.minus", button: self)
        case .mute:
            ButtonRepresentation(name: String(localized: "Mute"), systemImage: "speaker.slash", button: self)
        case .directionUp:
            ButtonRepresentation(name: String(localized: "Up"), systemImage: "dpad.up.fill", button: self)
        case .directionDown:
            ButtonRepresentation(name: String(localized: "Down"), systemImage: "dpad.down.fill", button: self)
        case .directionLeft:
            ButtonRepresentation(name: String(localized: "Left"), systemImage: "dpad.left.fill", button: self)
        case .directionRight:
            ButtonRepresentation(name: String(localized: "Right"), systemImage: "dpad.right.fill", button: self)
        case .select:
            ButtonRepresentation(name: String(localized: "Select"), systemImage: "x.circle", button: self)
        case .guide:
            ButtonRepresentation(name: String(localized: "Guide"), systemImage: "info.bubble", button: self)
        case .back:
            ButtonRepresentation(name: String(localized: "Back"), systemImage: "arrowshape.turn.up.backward", button: self)
        case .menu:
            ButtonRepresentation(name: String(localized: "Menu"), systemImage: "filemenu.and.selection", button: self)
        case .home:
            ButtonRepresentation(name: String(localized: "Home"), systemImage: "house", button: self)
        case .exit:
            ButtonRepresentation(name: String(localized: "Exit"), systemImage: "delete.backward", button: self)
        case .play:
            ButtonRepresentation(name: String(localized: "Play"), systemImage: "play", button: self)
        case .pause:
            ButtonRepresentation(name: String(localized: "Pause"), systemImage: "pause", button: self)
        case .playpause:
            ButtonRepresentation(name: String(localized: "Play/Pause"), systemImage: "playpause", button: self)
        case .stop:
            ButtonRepresentation(name: String(localized: "Stop"), systemImage: "stop", button: self)
        case .fastForward:
            ButtonRepresentation(name: String(localized: "Fast Forward"), systemImage: "forward", button: self)
        case .rewind:
            ButtonRepresentation(name: String(localized: "Rewind"), systemImage: "backward", button: self)
        case .nextTrack:
            ButtonRepresentation(name: String(localized: "Next Track"), systemImage: "forward.end", button: self)
        case .previousTrack:
            ButtonRepresentation(name: String(localized: "Previous Track"), systemImage: "backward.end", button: self)
        case .record:
            ButtonRepresentation(name: String(localized: "Record"), systemImage: "record.circle", button: self)
        case .green:
            ButtonRepresentation(name: String(localized: "Green"), systemImage: "g.circle", button: self)
        case .red:
            ButtonRepresentation(name: String(localized: "Red"), systemImage: "r.circle", button: self)
        case .blue:
            ButtonRepresentation(name: String(localized: "Blue"), systemImage: "b.circle", button: self)
        case .yellow:
            ButtonRepresentation(name: String(localized: "Yellow"), systemImage: "y.circle", button: self)
        case .numberZero:
            ButtonRepresentation(name: String(localized: "0"), systemImage: "0.square", button: self)
        case .numberOne:
            ButtonRepresentation(name: String(localized: "1"), systemImage: "1.square", button: self)
        case .numberTwo:
            ButtonRepresentation(name: String(localized: "2"), systemImage: "2.square", button: self)
        case .numberThree:
            ButtonRepresentation(name: String(localized: "3"), systemImage: "3.square", button: self)
        case .numberFour:
            ButtonRepresentation(name: String(localized: "4"), systemImage: "4.square", button: self)
        case .numberFive:
            ButtonRepresentation(name: String(localized: "5"), systemImage: "5.square", button: self)
        case .numberSix:
            ButtonRepresentation(name: String(localized: "6"), systemImage: "6.square", button: self)
        case .numberSeven:
            ButtonRepresentation(name: String(localized: "7"), systemImage: "7.square", button: self)
        case .numberEight:
            ButtonRepresentation(name: String(localized: "8"), systemImage: "8.square", button: self)
        case .numberNine:
            ButtonRepresentation(name: String(localized: "9"), systemImage: "9.square", button: self)
        case .channelUp:
            ButtonRepresentation(name: String(localized: "Channel Up"), systemImage: "chevron.up.square", button: self)
        case .channelDown:
            ButtonRepresentation(name: String(localized: "Channel Down"), systemImage: "chevron.down.square", button: self)
        case .brightnessUp:
            ButtonRepresentation(name: String(localized: "Brightness Up"), systemImage: "sun.max.fill", button: self)
        case .brightnessDown:
            ButtonRepresentation(name: String(localized: "Brightness Down"), systemImage: "sun.min", button: self)
        case .turnOn:
            ButtonRepresentation(name: String(localized: "Turn On"), systemImage: "poweron", button: self)
        case .turnOff:
            ButtonRepresentation(name: String(localized: "Turn Off"), systemImage: "poweroff", button: self)
        case .other:
            ButtonRepresentation(name: String(localized: "Other"), systemImage: "ellipsis", button: self)
         }
    }
}
