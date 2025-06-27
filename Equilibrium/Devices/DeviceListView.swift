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
    
    @State private var showDeviceCreationSheet: Bool = false
    
    @Sendable
    func getDevices() async {
        do {
            try await self.connectionHandler.getDevices()
        } catch {
            self.errorHandler.handle(error, while: "getting devices")
        }
    }
    
    var body: some View {
        List {
            if connectionHandler.devices.isEmpty {
                Text("No devices found.")
                Button {
                    self.showDeviceCreationSheet = true
                } label: {
                    Label("Create one now?", systemImage: "plus")
                }
            }
            
            ForEach(connectionHandler.devices) { device in
                DeviceListItem(device: device)
            }
        }
        .task(getDevices)
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
