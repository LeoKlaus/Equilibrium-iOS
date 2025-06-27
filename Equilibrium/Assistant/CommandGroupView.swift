//
//  CommandGroupView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct CommandGroupView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State var device: Device
    @State var commandGroup: CommandGroupType
    
    var matchingCommands: [Command] {
        guard let commands = device.commands else {
            return []
        }
        
        return commands.filter { command in
            command.commandGroup == self.commandGroup
        }
    }
    
    var availableButtons: [RemoteButton] {
        commandGroup.associatedButtons.filter { button in
            !(device.commands?.contains(where: { $0.button == button }) ?? false) || (button == .other)
        }
    }
    
    func sendCommand(_ command: Command) {
        guard let commandId = command.id else {
            return
        }
        Task {
            do {
                try await self.connectionHandler.sendCommand(commandId)
            } catch {
                self.errorHandler.handle(error, while: "sending command")
            }
        }
    }
    
    @Sendable
    func refreshDevice() async {
        guard let deviceId = self.device.id else {
            return
        }
        do {
            self.device = try await self.connectionHandler.getDevice(deviceId)
        } catch {
            self.errorHandler.handle(error, while: "refreshing device")
        }
    }
    
    var body: some View {
        List {
            if !(matchingCommands.isEmpty) {
                Section("Recorded Commands") {
                    ForEach(matchingCommands) { command in
                        Menu {
                            Button("Test \(command.name)") {
                                self.sendCommand(command)
                            }
                        } label: {
                            Text(command.name)
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            
            if !availableButtons.isEmpty {
                Section("Available Commands") {
                    ForEach(availableButtons, id: \.rawValue) { button in
                        NavigationLink(destination: CreateCommandView(button: button, device: self.device, commandGroup: self.commandGroup)) {
                            Text(button.buttonRepresentation.name)
                        }
                    }
                }
            }
            
            Section {
                NavigationLink {
                    switch self.commandGroup {
                    case .other:
                        List {
                            Text("\(device.name) is now ready to use!")
                            Button("Done") {
                                self.dismiss()
                            }
                        }
                    default:
                        DeviceCommandAssistant(device: self.device, currentCommandGroup: self.commandGroup.nextType)
                    }
                } label: {
                    Text("Next")
                        .foregroundStyle(.accent)
                }
            }
        }
        .task(self.refreshDevice)
    }
}

#Preview("Power") {
    NavigationStack {
        CommandGroupView(device: .mockTV, commandGroup: .power)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}


#Preview("Volume") {
    NavigationStack {
        CommandGroupView(device: .mockTV, commandGroup: .volume)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}

#Preview("Other") {
    NavigationStack {
        CommandGroupView(device: Device(id: 1, name: "TestDevice", type: .other, commands: [Command(name: "TestCommand", button: .other, type: .bluetooth, commandGroup: .other)]), commandGroup: .other)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
