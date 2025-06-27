//
//  CommandGroupType+DescriptionText.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import EquilibriumAPI
import Foundation

extension CommandGroupType {
    
    var nextType: CommandGroupType {
        switch self {
        case .power:
            .volume
        case .volume:
            .navigation
        case .navigation:
            .transport
        case .transport:
            .channel
        case .coloredButtons:
            .other
        case .channel:
            .numeric
        case .numeric:
            .input
        case .input:
            .coloredButtons
        case .other:
            .power
        }
    }
    
    var descriptionText: String {
        switch self {
        case .power:
            String(localized: """
To begin, get the original remote of this device and check if it has any Power buttons:
- Power toggle
- Power on
- Power off
""")
        case .volume:
            String(localized: """
Does the original remote of your device have any Volume buttons:
- Volume Up
- Volume Down
- Mute
""")
        case .navigation:
            String(localized: """
Does the original remote of your device have any Navigation buttons:
- Up
- Down
- Left
- Right
- Select/Ok
- Back
- Menu
- Exit
- Guide
""")
        case .transport:
            String(localized: """
Does the original remote of your device have any Transport buttons:
- Play/Pause
- Stop
- Fast Forward
- Rewind
- Record
""")
        case .coloredButtons:
            String(localized: """
Does the original remote of your device have any Colored buttons?
""")
        case .channel:
            String(localized: """
Does the original remote of your device have any Channel buttons:
- Channel Up
- Channel Down
""")
        case .numeric:
            String(localized: """
Does the original remote of your device have any Numeric buttons?
""")
        case .input:
            String(localized: """
Does the original remote of your device have any Input buttons?
""")
        case .other:
            String(localized: "Add any remaining buttons here.")
        }
    }
}
