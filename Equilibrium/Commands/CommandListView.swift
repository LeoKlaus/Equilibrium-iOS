//
//  CommandListView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct CommandListView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @State private var commands: [Command] = []
    @State private var isLoading = true
    
    @State private var showDeleteConfirmation: Bool = false
    @State private var commandsToDelete: IndexSet? = nil
    
    @State private var showCreateSheet: Bool = false
    
    @Sendable func getCommands() async {
        do {
            self.commands = try await connectionHandler.getCommands()
            self.isLoading = false
        } catch {
            self.errorHandler.handle(error, while: "fetching commands")
            self.isLoading = false
        }
    }
    
    func deleteCommand(_ command: Command) {
        if let index = self.commands.firstIndex(of: command) {
            self.commandsToDelete = IndexSet(integer: index)
            self.showDeleteConfirmation = true
        }
    }
    
    func deleteCommands() {
        guard let commandsToDelete else {
            return
        }
        Task {
            do {
                for index in commandsToDelete {
                    if let commandId = commands[index].id {
                        try await self.connectionHandler.deleteCommand(commandId)
                    }
                }
                commands.remove(atOffsets: commandsToDelete)
            } catch {
                self.errorHandler.handle(error, while: "deleting commands")
            }
            self.commandsToDelete = nil
        }
    }
    
    var body: some View {
        List {
            if isLoading {
                HStack {
                    ProgressView()
                    Text("Loading commands from hub...")
                }
                .task(self.getCommands)
            } else {
                if self.commands.isEmpty {
                    Text("No commands found")
                }
                ForEach(self.commands) { command in
                    Menu {
                        Button {
                            guard let commandId = command.id else {
                                self.errorHandler.handle("Command has no ID", while: "sending command")
                                return
                            }
                            Task {
                                do {
                                    try await self.connectionHandler.sendCommand(commandId)
                                } catch {
                                    self.errorHandler.handle(error, while: "sending command")
                                }
                            }
                        } label: {
                            Label("Send command", systemImage: "paperplane")
                        }
                        Divider()
                        Button(role: .destructive) {
                            deleteCommand(command)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        HStack {
                            Text(command.name)
                            Spacer()
                        }
                        .contentShape(.rect)
                    }
                    .foregroundStyle(.primary)
                }
                .onDelete(perform: { index in
                    self.commandsToDelete = index
                    self.showDeleteConfirmation = true
                })
            }
        }
        .refreshable(action: self.getCommands)
        .alert("Delete \(commandsToDelete?.count ?? 0) commands?", isPresented: $showDeleteConfirmation) {
            Button("Yes", role: .destructive, action: deleteCommands)
            Button("Cancel", role: .cancel) {
                self.commandsToDelete = nil
            }
        }
        .sheet(isPresented: $showCreateSheet) {
            CreateCommandView()
                .onDisappear {
                    Task {
                        await getCommands()
                    }
                }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    self.showCreateSheet.toggle()
                } label: {
                    Label("Add Command", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    ImageListView()
}
