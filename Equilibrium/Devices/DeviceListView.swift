//
//  DeviceListView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct DeviceListView: View {
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State private var isLoading: Bool = true
    
    @State private var showDeviceCreationSheet: Bool = false
    
    @Sendable
    func getDevices() async {
        self.isLoading = true
        do {
            try await self.connectionHandler.getDevices()
        } catch {
            self.errorHandler.handle(error, while: "getting devices")
        }
        self.isLoading = false
    }
    
    func sencCommand(commandId: Int) {
        Task {
            do {
                try await self.connectionHandler.sendCommand(commandId)
            } catch {
                self.errorHandler.handle(error, while: "sending command")
            }
        }
    }
    
    var body: some View {
        List {
            if connectionHandler.devices.isEmpty {
                if isLoading {
                    Label {
                        Text("Loading devices...")
                    } icon: {
                        ProgressView()
                    }
                } else {
                    Text("No devices found.")
                    Button {
                        self.showDeviceCreationSheet = true
                    } label: {
                        Label("Create one now?", systemImage: "plus")
                    }
                }
            }
            
            ForEach(connectionHandler.devices) { device in
                NavigationLink(destination: DeviceDetailView(device: device)) {
                    DeviceListItem(device: device)
                }.contextMenu {
                    if let toggleCommandId = device.commands?.first(where: { $0.button == .powerToggle })?.id {
                        Button {
                            self.sencCommand(commandId: toggleCommandId)
                        } label: {
                            Label("Toggle Power", systemImage: "power")
                        }
                    }
                    if let onCommandId = device.commands?.first(where: { $0.button == .powerOn })?.id {
                        Button {
                            self.sencCommand(commandId: onCommandId)
                        } label: {
                            Label("Turn On", systemImage: "togglepower")
                        }
                    }
                    if let offCommandId = device.commands?.first(where: { $0.button == .powerOff })?.id {
                        Button(role: .destructive) {
                            self.sencCommand(commandId: offCommandId)
                        } label: {
                            Label("Turn Off", systemImage: "poweroff")
                        }
                    }
                    Divider()
                    NavigationLink(destination: BasicDeviceCreationView(device: device)) {
                        Label("Edit \(device.name)", systemImage: "pencil")
                    }
                }
            }
        }
        .navigationTitle("Devices")
        .task(self.getDevices)
        .refreshable(action: self.getDevices)
        .sheet(isPresented: $showDeviceCreationSheet) {
            NavigationStack {
                BasicDeviceCreationView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    self.showDeviceCreationSheet = true
                } label: {
                    Label("Add Device", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeviceListView()
    }
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
    .withErrorHandling()
}
