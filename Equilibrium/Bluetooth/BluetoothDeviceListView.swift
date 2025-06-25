//
//  BluetoothDeviceListView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 24.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct BluetoothDeviceListView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @State private var isLoading: Bool = true
    
    @State private var bleDevices: [BleDevice] = []
    
    @Sendable func getConnectedDevices() async {
        self.isLoading = true
        do {
            self.bleDevices = try await self.connectionHandler.getBleDevices()
        } catch {
            self.errorHandler.handle(error, while: "getting connected bluetooth devices from hub")
        }
        self.isLoading = false
    }
    
    var body: some View {
        List {
            if isLoading {
                HStack {
                    ProgressView()
                    Text("Loading devices from hub...")
                }
                .task(self.getConnectedDevices)
            } else {
                if bleDevices.isEmpty {
                    Text("No bluetooth devices connected")
                }
                
                ForEach(bleDevices) { device in
                    Menu {
                        if device.connected {
                            Button("Disconnect from \(device.name)") {
                                Task {
                                    do {
                                        try await self.connectionHandler.disconnectBleDevices()
                                    } catch {
                                        self.errorHandler.handle(error, while: "disconnecting bluetooth devices")
                                    }
                                }
                            }
                        } else {
                            Button("Connect to \(device.name)") {
                                Task {
                                    do {
                                        try await self.connectionHandler.connectBleDevices(device.address)
                                    } catch {
                                        self.errorHandler.handle(error, while: "disconnecting bluetooth devices")
                                    }
                                }
                            }
                        }
                    } label: {
                        BluetoothDeviceListItem(device: device)
                    }
                    .foregroundStyle(.primary)
                }
                
                Section {
                    Button {
                        Task {
                            do {
                                try await self.connectionHandler.advertiseBle()
                            } catch {
                                self.errorHandler.handle(error, while: "enabling discovery")
                            }
                        }
                    } label: {
                        Label("Enable discovery", systemImage: "eye.fill")
                    }
                }
            }
        }
        .refreshable(action: self.getConnectedDevices)
    }
}

#Preview {
    BluetoothDeviceListView()
        .withErrorHandling()
        .environment(HubConnectionHandler())
}
