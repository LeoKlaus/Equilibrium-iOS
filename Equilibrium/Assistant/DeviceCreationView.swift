//
//  DeviceCreationView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 24.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct DeviceCreationView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @State private var responseText: String = ""
    
    func callback(_ response: IrResponse) {
        print(response)
        switch response {
        case .pressKey:
            responseText.append("Press key\n")
        case .repeatKey:
            responseText.append("Repeat key\n")
        case .shortCode:
            responseText.append("Short code, repeat key\n")
        case .done:
            responseText.append("Done!\n")
        case .cancelled:
            responseText.append("Cancelled!\n")
        case .tooManyRetries:
            responseText.append("Too many retries, cancelling...\n")
        }
    }
    
    
    var body: some View {
        ScrollView {
            Text(responseText)
            Button("Create Command") {
                self.responseText = ""
                Task {
                    do {
                        try await connectionHandler.createIrCommand(
                            command: Command(name: "Power", button: .powerToggle, type: .ir),
                            callback: self.callback
                        )
                    } catch {
                        self.errorHandler.handle(error, while: "creating ir command")
                    }
                }
            }
        }
    }
}

#Preview {
    DeviceCreationView()
        .withErrorHandling()
        .environment(HubConnectionHandler())
}
