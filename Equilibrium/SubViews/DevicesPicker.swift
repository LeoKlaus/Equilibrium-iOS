//
//  DevicesPicker.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 30.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct DevicesPicker: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @Binding var selectedDevices: [Device]
    
    @Sendable
    func getDevices() async {
        do {
            try await self.connectionHandler.getDevices()
        } catch {
            self.errorHandler.handle(error, while: "getting devices from hub")
        }
    }
    
    var body: some View {
        List {
            if connectionHandler.devices.isEmpty {
                Text("No devices found.")
            } else {
                ForEach(connectionHandler.devices) { device in
                    Button {
                        if self.selectedDevices.contains(device) {
                            self.selectedDevices.removeAll(where: {$0 == device})
                        } else {
                            self.selectedDevices.append(device)
                        }
                    } label: {
                        if self.selectedDevices.contains(device) {
                            HStack {
                                Text(device.name)
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        } else {
                            Text(device.name)
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
        .task(self.getDevices)
        .refreshable(action: self.getDevices)
    }
}

#Preview {
    @Previewable @State var devices: [Device] = [.mockTV]
    DevicesPicker(selectedDevices: $devices)
        .withErrorHandling()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
