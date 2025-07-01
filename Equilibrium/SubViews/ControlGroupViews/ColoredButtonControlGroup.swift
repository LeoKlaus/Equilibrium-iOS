//
//  ColoredButtonControlGroup.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 30.06.25.
//


import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct ColoredButtonControlGroup: View {
    
    let commands: [Command]
    
    var body: some View {
        Grid(horizontalSpacing: 30, verticalSpacing: 30) {
            GridRow {
                commandButtonIfExists(.red, systemImage: "rectangle.fill")
                    .foregroundStyle(.red)
                commandButtonIfExists(.green, systemImage: "rectangle.fill")
                    .foregroundStyle(.green)
                commandButtonIfExists(.yellow, systemImage: "rectangle.fill")
                    .foregroundStyle(.yellow)
                commandButtonIfExists(.blue, systemImage: "rectangle.fill")
                    .foregroundStyle(.blue)
            }
        }
    }
    
    func commandButtonIfExists(_ button: RemoteButton, systemImage: String? = nil, useName: Bool = false) -> some View {
        VStack {
            if let command = self.commands.first(where: {$0.button == button}) {
                CommandButton(command: command, systemImage: systemImage, text: useName ? command.name : nil)
                    .frame(width: 40, height: 40)
            } else {
                Text(verbatim: "")
            }
        }
    }
}

#Preview {
    ColoredButtonControlGroup(commands: [
        .mockRed,
        .mockBlue,
        .mockGreen,
        .mockYellow
    ])
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
