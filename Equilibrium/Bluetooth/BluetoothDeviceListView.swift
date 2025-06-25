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
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @State private var isLoading: Bool = true
    
    @State private var bleDevices: [BleDevice] = []
    
    let isPicker: Bool
    @Binding var selectedDevice: BleDevice?
    
    @Sendable func getConnectedDevices() async {
        self.isLoading = true
        do {
            self.bleDevices = try await self.connectionHandler.getBleDevices()
        } catch {
            self.errorHandler.handle(error, while: "getting connected bluetooth devices from hub")
        }
        self.isLoading = false
    }
    
    init() {
        self.isPicker = false
        self._selectedDevice = .constant(nil)
    }
    
    init(selectedDevice: Binding<BleDevice?>) {
        self.isPicker = true
        self._selectedDevice = selectedDevice
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
                    if isPicker {
                        Button {
                            self.selectedDevice = device
                            self.dismiss()
                        } label: {
                            HStack {
                                BluetoothDeviceListItem(device: device)
                                if selectedDevice?.address == device.address {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.accent)
                                }
                            }
                        }
                        .foregroundStyle(.primary)
                    } else {
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
                }
                
                if isPicker {
                    Button {
                        self.selectedDevice = nil
                        self.dismiss()
                    } label: {
                        HStack {
                            Text("None")
                            Spacer()
                            if self.selectedDevice == nil {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.accent)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
                
                Section {
                    Text("To pair Equilibrium to a new bluetooth device, enable discovery here first and then connect to **Equilibrium Virtual Keyboard** from the bluetooth settings of your device. For some devices (notably Apple TVs), pairing does not start automatically after connecting.\nIn that case, use the **Pair devices** button below to manually initiate pairing.")
                    Button {
                        Task {
                            do {
                                try await self.connectionHandler.advertiseBle()
                            } catch {
                                self.errorHandler.handle(error, while: "enabling discovery")
                            }
                        }
                    } label: {
                        Label("Enable discovery", systemImage: "eyes")
                    }
                    Button {
                        Task {
                            do {
                                try await self.connectionHandler.pairBle()
                            } catch {
                                self.errorHandler.handle(error, while: "starting pairing")
                            }
                        }
                    } label: {
                        Label("Pair devices", systemImage: "link.badge.plus")
                    }
                } footer: {
                    Text("Warning: The Bluetooth integration in Equilibrium is in the earlier stages of development. While connecting to paired devices and controlling them (usually) works reliably, pairing can take a few attempts to work.")
                }
            }
        }
        .refreshable(action: self.getConnectedDevices)
    }
}

#Preview {
    BluetoothDeviceListView()
        .withErrorHandling()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
