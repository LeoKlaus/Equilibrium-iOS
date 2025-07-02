//
//  MacroListView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 01.07.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct MacroListView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @State private var macros: [Macro] = []
    @State private var isLoading = true
    
    @State private var showCreationSheet: Bool = false
    
    @State private var showDeleteConfirmation: Bool = false
    @State private var macrosToDelete: IndexSet? = nil
    
    let isPicker: Bool
    @Binding var selectedMacro: Macro?
    
    init() {
        self._selectedMacro = .constant(nil)
        self.isPicker = false
    }
    
    init(selectedMacro: Binding<Macro?>) {
        self._selectedMacro = selectedMacro
        self.isPicker = true
    }
    
    @Sendable func getMacros() async {
        self.isLoading = true
        do {
            self.macros = try await connectionHandler.getMacros()
            self.isLoading = false
        } catch {
            if !Task.isCancelled {
                self.errorHandler.handle(error, while: "fetching macros")
                self.isLoading = false
            }
        }
    }
    
    func deleteMacro(_ macro: Macro) {
        if let index = self.macros.firstIndex(of: macro) {
            self.macrosToDelete = IndexSet(integer: index)
            self.showDeleteConfirmation = true
        }
    }
    
    func deleteMacros() {
        guard let macrosToDelete else {
            return
        }
        Task {
            do {
                for index in macrosToDelete {
                    if let macroId = macros[index].id {
                        try await self.connectionHandler.deleteMacro(macroId)
                    }
                }
                self.macros.remove(atOffsets: macrosToDelete)
            } catch {
                self.errorHandler.handle(error, while: "deleting macros")
            }
            self.macrosToDelete = nil
        }
    }
    
    func sendMacro(_ macro: Macro) {
        guard let macroId = macro.id else {
            self.errorHandler.handle("\(macro.name ?? "Macro") has no id", while: "executing macro")
            return
        }
        Task {
            do {
                try await self.connectionHandler.sendMacro(macroId)
            } catch {
                self.errorHandler.handle(error, while: "executing macro")
            }
        }
    }
    
    var body: some View {
        List {
            if isLoading {
                HStack {
                    ProgressView()
                    Text("Loading macros from hub...")
                }
                    .task(getMacros)
            } else {
                if self.macros.isEmpty {
                    Text("No macros found")
                }
                ForEach(self.macros) { macro in
                    if isPicker {
                        Button {
                            self.selectedMacro = macro
                            self.dismiss()
                        } label: {
                            HStack {
                                MacroListItem(macro: macro)
                                Spacer()
                                if selectedMacro?.id == macro.id {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.accent)
                                }
                            }
                            .contentShape(.rect)
                        }
                        .foregroundStyle(.primary)
                    } else {
                        Menu {
                            Button {
                                self.sendMacro(macro)
                            } label: {
                                Label("Execute \(macro.name ?? "")", systemImage: "paperplane")
                            }
                            
                            NavigationLink(destination: CreateMacroView(macro: macro)) {
                                Label("Edit \(macro.name ?? "macro")", systemImage: "pencil")
                            }
                            Divider()
                            Button(role: .destructive) {
                                deleteMacro(macro)
                            } label: {
                                Label("Delete \(macro.name ?? "macro")", systemImage: "trash")
                            }
                        } label: {
                            MacroListItem(macro: macro)
                            .contentShape(.rect)
                        }
                        .foregroundStyle(.primary)
                    }
                }
                .onDelete(perform: { index in
                    self.macrosToDelete = index
                    self.showDeleteConfirmation = true
                })
                
                if isPicker {
                    Button {
                        self.selectedMacro = nil
                        self.dismiss()
                    } label: {
                        HStack {
                            Text("None")
                            Spacer()
                            if selectedMacro == nil {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.accent)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .refreshable(action: self.getMacros)
        .alert("Delete \(macrosToDelete?.count ?? 0) macros?", isPresented: $showDeleteConfirmation) {
            Button("Yes", role: .destructive, action: deleteMacros)
            Button("Cancel", role: .cancel) {
                self.macrosToDelete = nil
            }
        }
        .sheet(isPresented: $showCreationSheet) {
            NavigationStack {
                CreateMacroView()
                    .onDisappear {
                        Task {
                            await getMacros()
                        }
                    }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    self.showCreationSheet.toggle()
                } label: {
                    Label("Add Macro", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MacroListView()
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}

#Preview("Picker") {
    @Previewable @State var selectedMacro: Macro? = nil
    NavigationStack {
        MacroListView(selectedMacro: $selectedMacro)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
