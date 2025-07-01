//
//  CommandPicker.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 01.07.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct CommandPicker: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @Binding var selectedCommand: Command?
    
    @State private var device: Device?
    
    private var matchingCommands: [Command] {
        if let device {
            return device.commands ?? []
        } else {
            var commands: [Command] = []
            for device in self.connectionHandler.devices {
                commands += device.commands ?? []
            }
            return commands
        }
    }
    
    @Sendable
    func getDevices() async {
        do {
            try await self.connectionHandler.getDevices()
        } catch {
            self.errorHandler.handle(error, while: "getting devices from hub")
        }
    }
    
    var body: some View {
        List {
            Picker("Device", selection: $device) {
                ForEach(self.connectionHandler.devices) { device in
                    Text(device.name).tag(device)
                }
                Divider()
                Text("None (show all)").tag(nil as Device?)
            }
            
            Section("Commands") {
                ForEach(self.matchingCommands) { command in
                    Button {
                        self.selectedCommand = command
                        self.dismiss()
                    } label: {
                        CommandListItem(command: command)
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .task(self.getDevices)
    }
}

#Preview {
    @Previewable @State var selectedCommand: Command?
    CommandPicker(selectedCommand: $selectedCommand)
        .withErrorHandling()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
