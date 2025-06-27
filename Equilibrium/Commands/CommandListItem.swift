//
//  CommandListItem.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 26.06.25.
//

import SwiftUI
import EquilibriumAPI

struct CommandListItem: View {
    
    let command: Command
    
    var body: some View {
        VStack(alignment: .leading) {
            Label {
                Text(command.name)
                    .bold()
                HStack {
                    Text(command.device?.name ?? "No device")
                    Text("-")
                    Text(command.commandGroup.localizedName)
                }
                .foregroundStyle(.secondary)
            } icon: {
                Image(systemName: command.button.buttonRepresentation.systemImage)
                    .foregroundStyle(.accent)
            }
        }
    }
}

#Preview {
    List {
        CommandListItem(command: .mockPowerToggle)
        CommandListItem(command: Command(name: "Send Web Request", button: .other, type: .network, commandGroup: .other))
    }
}
