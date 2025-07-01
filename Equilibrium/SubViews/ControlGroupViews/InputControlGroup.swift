//
//  InputControlGroup.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 30.06.25.
//


import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct InputControlGroup: View {
    
    let commands: [Command]
    
    let colums = [
        GridItem(.fixed(60)),
        GridItem(.fixed(60)),
        GridItem(.fixed(60)),
        GridItem(.fixed(60)),
        GridItem(.fixed(60))
    ]
    
    var body: some View {
        LazyVGrid(columns: self.colums) {
            ForEach(commands.filter{ $0.commandGroup == .input }) { command in
                CommandButton(command: command, text: command.name)
                    .frame(maxWidth: 50, maxHeight: 30)
                    .bold()
            }
        }
    }
}

#Preview {
    InputControlGroup(commands: [
        .mockLiveTV,
        .mockHDMIOne,
        .mockHDMITwo,
        .mockHDMIThree,
        .mockComposite,
        Command(id: 50, name: "Test", button: .other, type: .ir, commandGroup: .input)
    ])
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
