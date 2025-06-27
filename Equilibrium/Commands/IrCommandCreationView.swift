//
//  IrCommandCreationView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct IrCommandCreationView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    let command: Command
    @State var currentState: IrResponse?
    
    @State private var isRecording: Bool = false
    
    @State private var websocketTask: Task<(), Never>? = nil
    
    var afterFinish: () -> Void = {}
    
    func callback(_ response: IrResponse) {
        withAnimation {
            self.currentState = response
        }
        if response == .done {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.dismiss()
            }
        }
    }
    
    var body: some View {
        HStack {
            if let currentState {
                switch currentState {
                case .pressKey:
                    Label {
                        Text("Press key for \(command.name)")
                    } icon: {
                        ProgressView()
                    }
                case .repeatKey:
                    Label {
                        Text("Press key for \(command.name) again")
                    } icon: {
                        ProgressView()
                    }
                case .shortCode:
                    Label {
                        Text("Received code was too short, press the key again...")
                    } icon: {
                        ProgressView()
                    }
                case .done:
                    Label {
                        Text("Done, command \(command.name) created!")
                    } icon: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                case .cancelled:
                    Label {
                        Text("Recording was cancelled by the hub. Please try again.")
                    } icon: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                case .tooManyRetries:
                    Label {
                        Text("Retried to many times, cancelling...")
                    } icon: {
                        Image(systemName: "exclamationmark.arrow.circlepath")
                            .foregroundStyle(.red)
                    }
                }
            } else {
                Button {
                    websocketTask = Task {
                        do {
                            try await self.connectionHandler.createIrCommand(
                                command: command,
                                callback: self.callback
                            )
                        } catch {
                            self.errorHandler.handle(error, while: "creating ir command")
                        }
                    }
                } label: {
                    Text("Start Recording \(command.name)")
                }
                .disabled(isRecording)
            }
        }
        .onDisappear {
            self.websocketTask?.cancel()
        }
    }
}

#Preview("Default") {
    List {
        IrCommandCreationView(command: .mockPowerToggle)
    }
    .withErrorHandling()
    .environment(HubConnectionHandler())
}

#Preview("Ready to record") {
    List {
        IrCommandCreationView(command: .mockPowerToggle, currentState: .pressKey)
    }
    .withErrorHandling()
    .environment(HubConnectionHandler())
}

#Preview("Repeat Key") {
    List {
        IrCommandCreationView(command: .mockPowerToggle, currentState: .repeatKey)
    }
    .withErrorHandling()
    .environment(HubConnectionHandler())
}

#Preview("Short Code") {
    List {
        IrCommandCreationView(command: .mockPowerToggle, currentState: .shortCode)
    }
    .withErrorHandling()
    .environment(HubConnectionHandler())
}


#Preview("Done") {
    List {
        IrCommandCreationView(command: .mockPowerToggle, currentState: .done)
    }
    .withErrorHandling()
    .environment(HubConnectionHandler())
}

#Preview("Too many retries") {
    List {
        IrCommandCreationView(command: .mockPowerToggle, currentState: .tooManyRetries)
    }
    .withErrorHandling()
    .environment(HubConnectionHandler())
}

#Preview("Cancelled") {
    List {
        IrCommandCreationView(command: .mockPowerToggle, currentState: .cancelled)
    }
    .withErrorHandling()
    .environment(HubConnectionHandler())
}
