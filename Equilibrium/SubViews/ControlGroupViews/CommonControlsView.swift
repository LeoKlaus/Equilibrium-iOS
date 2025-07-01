//
//  CommonControlsView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 30.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct CommonControlsView: View {
    
    let devices: [Device]
    
    
    var inputController: Device? {
        self.devices.first(where: { $0.type == .display }) ??
        self.devices.first(where: { $0.type == .other })
    }
    
    var audioController: Device? {
        self.devices.first(where: { $0.type == .amplifier }) ??
        self.devices.first(where: { $0.type == .player }) ??
        self.devices.first(where: { $0.type == .display }) ??
        self.devices.first(where: { $0.type == .other })
    }
    
    var navigationController: Device? {
        self.devices.first(where: { $0.type == .player }) ??
        self.devices.first(where: { $0.type == .display }) ??
        self.devices.first(where: { $0.type == .other })
    }
    
    var channelController: Device? {
        self.devices.first(where: { $0.type == .player }) ??
        self.devices.first(where: { $0.type == .display }) ??
        self.devices.first(where: { $0.type == .other })
    }
    
    var body: some View {
        Grid(horizontalSpacing: 45, verticalSpacing: 45) {
            if let inputController {
                InputControlGroup(commands: inputController.commands ?? [])
                    .frame(width: 250)
            }
            GridRow {
                if let audioController {
                    VolumeControlGroup(commands: audioController.commands ?? [])
                }
                if let navigationController {
                    NavigationControlGroup(commands: navigationController.commands ?? [])
                }
                if let channelController {
                    ChannelControlGroup(commands: channelController.commands ?? [])
                }
            }
            TransportControlGroup(commands: channelController?.commands ?? [])
            ColoredButtonControlGroup(commands: channelController?.commands ?? [])
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    CommonControlsView(devices: [
        .mockTV,
        .mockAmplifier,
        .mockPlayer
    ])
        .withErrorHandling()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
