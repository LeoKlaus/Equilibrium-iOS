//
//  TransportControlGroup.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 30.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct TransportControlGroup: View {
    
    let commands: [Command]
    
    var body: some View {
        Grid(horizontalSpacing: 30, verticalSpacing: 30) {
            GridRow {
                commandButtonIfExists(.play)
                commandButtonIfExists(.pause)
                commandButtonIfExists(.playpause)
                commandButtonIfExists(.stop)
                commandButtonIfExists(.record, systemImage: "smallcircle.filled.circle.fill")
                    .foregroundStyle(.red)
            }
            GridRow {
                commandButtonIfExists(.previousTrack)
                commandButtonIfExists(.rewind)
                Text(verbatim: "")
                commandButtonIfExists(.fastForward)
                commandButtonIfExists(.nextTrack)
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
    Grid {
        GridRow {
            TransportControlGroup(commands: [
                .mockPlayPause,
                .mockPlay,
                .mockPause,
                .mockStop,
                .mockFastForward,
                .mockRewind,
                .mockNextTrack,
                .mockPreviousTrack,
                .mockRecord
            ])
        }
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
