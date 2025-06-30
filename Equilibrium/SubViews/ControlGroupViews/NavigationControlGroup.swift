//
//  NavigationControlGroup.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 29.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct NavigationControlGroup: View {
    
    let commands: [Command]
    
    var body: some View {
        
        Grid(alignment: .center, horizontalSpacing: 30, verticalSpacing: 30) {
            GridRow {
                commandButtonIfExists(.exit, useName: true)
                commandButtonIfExists(.directionUp, systemImage: "arrowshape.up.circle")
                commandButtonIfExists(.guide, useName: true)
            }
            GridRow {
                commandButtonIfExists(.directionLeft, systemImage: "arrowshape.left.circle")
                commandButtonIfExists(.select)
                commandButtonIfExists(.directionRight, systemImage: "arrowshape.right.circle")
            }
            GridRow {
                commandButtonIfExists(.menu, useName: true)
                commandButtonIfExists(.directionDown, systemImage: "arrowshape.down.circle")
                commandButtonIfExists(.back, useName: true)
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
    NavigationControlGroup(commands: [
        .mockUp,
        .mockDown,
        .mockLeft,
        .mockRight,
        .mockSelect,
        .mockBack,
        .mockMenu,
        .mockExit,
        .mockGuide
    ])
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
