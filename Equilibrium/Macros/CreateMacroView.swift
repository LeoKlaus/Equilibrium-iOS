//
//  CreateMacroView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 01.07.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct CreateMacroView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    let isEditView: Bool
    let id: Int?
    
    @State private var name: String = ""
    @State private var commands: [Command] = []
    @State private var delays: [Int] = []
    
    @State private var availableCommands: [Command] = []
    
    @State private var isSaving: Bool = false
    
    init() {
        self.isEditView = false
        self.id = nil
    }
    
    init(macro: Macro) {
        self.isEditView = false
        self.id = macro.id
        self._name = State(initialValue: macro.name ?? "")
        self._commands = State(initialValue: macro.commands ?? [])
        self._delays = State(initialValue: macro.delays)
    }
    
    @Sendable
    func getCommands() async {
        do {
            self.availableCommands = try await self.connectionHandler.getCommands()
        } catch {
            self.errorHandler.handle(error, while: "getting commands from hub")
        }
    }
    
    func saveMacro() {
        self.isSaving = true
        
        guard delays.count == commands.count - 1 else {
            self.errorHandler.handle("Command and delay counts don't match, this is definitely a bug!", while: "saving macro")
            self.isSaving = false
            return
        }
        
        let macro = Macro(id: self.id, name: self.name, commands: self.commands, delays: self.delays)
        Task {
            do {
                if self.isEditView {
                    _ = try await self.connectionHandler.updateMacro(macro)
                } else {
                    _ = try await self.connectionHandler.createMacro(macro)
                }
            } catch {
                self.errorHandler.handle(error, while: "saving macro")
            }
            self.isSaving = false
        }
    }
    
    var body: some View {
        List {
            TextField("Name", text: self.$name)
            
            Section {
                ForEach(Array(self.commands.enumerated()), id: \.offset) { index, command in
                    VStack(alignment: .leading) {
                        Text(command.name)
                        if index < delays.count {
                            HStack {
                                Text("Delay after (in ms): ")
                                TextField("Delay", value: $delays[index], formatter: NumberFormatter())
                            }
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                        }
                    }
                }
                .onMove { index, x in
                    self.commands.move(fromOffsets: index, toOffset: x)
                }
                .onDelete { offsets in
                    for index in offsets {
                        self.commands.remove(at: index)
                        if delays.count > index {
                            self.delays.remove(at: index)
                        } else if delays.count == index && !delays.isEmpty {
                            self.delays.remove(at: index - 1)
                        }
                    }
                }
                
                NavigationLink(
                    destination: CommandPicker(
                        selectedCommand: Binding(
                            get: {
                                return nil as Command?
                            }, set: { newValue in
                                if let newValue {
                                    if !self.commands.isEmpty {
                                        self.delays.append(0)
                                    }
                                    self.commands.append(newValue)
                                }
                            })
                    )
                ) {
                    Label("Add Command", systemImage: "plus")
                        .foregroundStyle(.accent)
                }
            } header: {
                Text("Commands")
            } footer: {
                Text("Drag to reorder, swipe left to remove commands.")
            }
            
            Button(action: self.saveMacro) {
                if isSaving {
                    HStack {
                        ProgressView()
                        Text("Saving macro...")
                    }
                } else {
                    if isEditView {
                        Label("Save Changes", systemImage: "square.and.arrow.down")
                    } else {
                        Label("Save Macro", systemImage: "square.and.arrow.down")
                    }
                }
            }
            .disabled(isSaving)
        }
        .task(self.getCommands)
    }
}

#Preview {
    NavigationStack {
        CreateMacroView()
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}

#Preview("Edit") {
    NavigationStack {
        CreateMacroView(macro: .mockStart)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
