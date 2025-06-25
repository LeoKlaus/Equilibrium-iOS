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
            ForEach(connectionHandler.devices) { device in
                DeviceListItem(device: device)
            }
        }
        .task(getDevices)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    
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
