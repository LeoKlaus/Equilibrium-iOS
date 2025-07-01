//
//  OtherControlGroup.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 30.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct OtherControlGroup: View {
    
    let devices: [Device]
    
    let colums = [
        GridItem(.fixed(60)),
        GridItem(.fixed(60)),
        GridItem(.fixed(60)),
        GridItem(.fixed(60)),
        GridItem(.fixed(60))
    ]
    
    var commands: [Command] {
        var cmds: [Command] = []
        
        for device in devices {
            cmds += device.commands?.filter{ $0.button == .other && $0.commandGroup != .input } ?? []
        }
        
        return cmds
    }
    
    var body: some View {
        if self.commands.isEmpty {
            EmptyView()
        } else {
            LazyVGrid(columns: self.colums) {
                ForEach(commands) { command in
                    CommandButton(command: command, text: command.name)
                        .frame(maxWidth: 50, maxHeight: 30)
                }
            }
            .foregroundStyle(.primary)
        }
    }
}

#Preview {
    OtherControlGroup(devices: [.mockPlayer])
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
        .withErrorHandling()
}
