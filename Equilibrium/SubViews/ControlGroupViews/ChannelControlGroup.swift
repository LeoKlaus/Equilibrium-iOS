//
//  ChannelControlGroup.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 30.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct ChannelControlGroup: View {
    
    let commands: [Command]
    
    var body: some View {
        
        Grid(alignment: .center, horizontalSpacing: 30, verticalSpacing: 30) {
            GridRow {
                commandButtonIfExists(.channelUp)
            }
            GridRow {
                commandButtonIfExists(.channelDown)
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
    ChannelControlGroup(commands: [
        .mockChannelUp,
        .mockChannelDown
    ])
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}

