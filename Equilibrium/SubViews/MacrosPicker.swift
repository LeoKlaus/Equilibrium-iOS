//
//  MacrosPicker.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 02.07.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct MacrosPicker: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @Binding var selectedMacros: [Macro]
    
    @State private var availableMacros: [Macro] = []
    
    @Sendable
    func getMacros() async {
        do {
            self.availableMacros = try await self.connectionHandler.getMacros()
        } catch {
            self.errorHandler.handle(error, while: "getting macros from hub")
        }
    }
    
    var body: some View {
        List {
            if self.availableMacros.isEmpty {
                Text("No macros found.")
            } else {
                ForEach(self.availableMacros) { macro in
                    Button {
                        if self.selectedMacros.contains(macro) {
                            self.selectedMacros.removeAll(where: {$0 == macro})
                        } else {
                            self.selectedMacros.append(macro)
                        }
                    } label: {
                        if self.selectedMacros.contains(macro) {
                            HStack {
                                Text(macro.name ?? "Macro \(macro.id ?? 0)")
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        } else {
                            Text(macro.name ?? "Macro \(macro.id ?? 0)")
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
            
            Section {
                Button("Done") {
                    self.dismiss()
                }
            }
        }
        .task(self.getMacros)
        .refreshable(action: self.getMacros)
    }
}

#Preview {
    @Previewable @State var macros: [Macro] = [.mock]
    MacrosPicker(selectedMacros: $macros)
        .withErrorHandling()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
