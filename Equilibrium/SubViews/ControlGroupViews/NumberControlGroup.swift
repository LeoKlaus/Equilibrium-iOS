//
//  NumberControlGroup.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 30.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct NumberControlGroup: View {
    
    let devices: [Device]
    
    var commands: [Command] {
        if let player = devices.first(where: { $0.type == .player }), player.commands?.contains(where: { $0.commandGroup == .numeric}) ?? false {
            return player.commands ?? []
        } else if let display = devices.first(where: { $0.type == .display }), display.commands?.contains(where: { $0.commandGroup == .numeric}) ?? false {
            return display.commands ?? []
        } else if let other = devices.first(where: { $0.type == .other }), other.commands?.contains(where: { $0.commandGroup == .numeric}) ?? false {
            return other.commands ?? []
        }
        return []
    }
    
    var body: some View {
        if commands.isEmpty {
            EmptyView()
        } else {
            Grid(horizontalSpacing: 30, verticalSpacing: 30) {
                GridRow {
                    commandButtonIfExists(.numberOne)
                    commandButtonIfExists(.numberTwo)
                    commandButtonIfExists(.numberThree)
                }
                GridRow {
                    commandButtonIfExists(.numberFour)
                    commandButtonIfExists(.numberFive)
                    commandButtonIfExists(.numberSix)
                }
                GridRow {
                    commandButtonIfExists(.numberSeven)
                    commandButtonIfExists(.numberEight)
                    commandButtonIfExists(.numberNine)
                }
                GridRow {
                    Text(verbatim: "")
                    commandButtonIfExists(.numberZero)
                }
            }
            .foregroundStyle(.primary)
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
    /*NumberControlGroup(commands: [
        .mockOne,
        .mockTwo,
        .mockThree,
        .mockFour,
        .mockFive,
        .mockSix,
        .mockSeven,
        .mockEight,
        .mockNine,
        .mockZero
    ])*/
    NumberControlGroup(devices: [.mockPlayer])
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
