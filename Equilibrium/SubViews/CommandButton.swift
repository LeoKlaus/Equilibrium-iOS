//
//  CommandButton.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 30.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct CommandButton: View {
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    let command: Command
    var systemImage: String? = nil
    var text: String? = nil
    
    func sendCommand() {
        guard let commandId = command.id else {
            self.errorHandler.handle("Command \(command.name) has no ID", while: "sending command")
            return
        }
        Task {
            ImpactGenerator.shared.impactOccured(style: .rigid)
            do {
                try await self.connectionHandler.sendCommand(commandId)
            } catch {
                self.errorHandler.handle(error, while: "sending command")
            }
        }
    }
    
    var body: some View {
        Button(action: sendCommand) {
            if let text {
                Text(text)
                    .font(.title)
                    .minimumScaleFactor(0.25)
            } else {
                Label {
                    Text(command.name)
                } icon: {
                    Image(systemName: self.systemImage ?? command.button.buttonRepresentation.systemImage)
                        .resizable()
                        .scaledToFit()
                }
                .labelStyle(.iconOnly)
            }
        }
    }
}

#Preview {
    Grid(horizontalSpacing: 30, verticalSpacing: 30) {
        GridRow {
            CommandButton(command: .mockUp, systemImage: "arrowshape.up.circle")
                .frame(width: 40, height: 40)
            CommandButton(command: .mockGuide)
                .frame(width: 40, height: 40)
        }
        GridRow {
            CommandButton(command: .mockExit, text: "Exit")
                .frame(width: 40, height: 40)
            CommandButton(command: .mockExit, text: "Long Text")
                .frame(width: 40, height: 40)
        }
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
