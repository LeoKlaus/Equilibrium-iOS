//
//  DeviceType+Image.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import EquilibriumAPI
import SwiftUI

extension DeviceType: @retroactive CaseIterable, @retroactive Identifiable {
    
    public var id: String {
        self.rawValue
    }
    
    public static var allCases: [DeviceType] {
        [
            .display,
            .amplifier,
            .player,
            .integration,
            .other
        ]
    }
    
    var name: LocalizedStringKey {
        switch self {
        case .display:
            "Display"
        case .amplifier:
            "Amplifier"
        case .player:
            "Player"
        case .integration:
            "Integration"
        case .other:
            "Other"
        }
    }
    
    var image: Image {
        switch self {
        case .display:
            Image(systemName: "display")
        case .amplifier:
            Image(systemName: "hifireceiver")
        case .player:
            Image(systemName: "tv.and.mediabox")
        case .integration:
            Image(systemName: "macwindow.badge.plus")
        case .other:
            Image(systemName: "cpu")
        }
    }
}
