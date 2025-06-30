//
//  DeviceDetailView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 30.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct DeviceDetailView: View {
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State var device: Device
    
    var isDevicePowered: Bool {
        guard let deviceId = self.device.id else {
            return false
        }
        return self.connectionHandler.currentSceneStatus?.devices?.states[deviceId]?.powered ?? false
    }
    
    @Sendable
    func getDevice() async {
        guard let deviceId = self.device.id else {
            self.errorHandler.handle("\(device.name) has no id", while: "getting device from hub")
            return
        }
        do {
            self.device = try await self.connectionHandler.getDevice(deviceId)
        } catch {
            self.errorHandler.handle(error, while: "getting device from hub")
        }
    }
    
    func sendCommand(_ id: Int) {
        Task {
            do {
                try await self.connectionHandler.sendCommand(id)
            } catch {
                self.errorHandler.handle(error, while: "sending command")
            }
        }
    }
    
    var body: some View {
        TabView {
            CommonControlsView(devices: [device])
        }
        .task(self.getDevice)
        .tabViewStyle(.page)
        .navigationTitle(device.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if self.isDevicePowered, let turnOffCommandId = device.commands?.first(where: { $0.button == .powerOff })?.id ?? device.commands?.first(where: { $0.button == .powerToggle })?.id {
                    Button(role: .destructive) {
                        self.sendCommand(turnOffCommandId)
                    } label: {
                        Image(systemName: "power.circle.fill")
                            .foregroundStyle(.red)
                    }
                    .accessibilityHint(Text("Turn \(device.name) off"))
                } else if let turnOnCommandId = device.commands?.first(where: { $0.button == .powerOn })?.id ?? device.commands?.first(where: { $0.button == .powerToggle })?.id {
                    Button {
                        self.sendCommand(turnOnCommandId)
                    } label: {
                        Image(systemName: "power.circle")
                            .foregroundStyle(.green)
                    }
                    .accessibilityHint(Text("Turn \(device.name) on"))
                }
            }
        }
    }
}

#Preview("On") {
    NavigationStack {
        DeviceDetailView(device: .mockPlayer)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler(sceneStatus: StatusReport(devices: DeviceStates(states: [2: DeviceState(powered: true, input: nil)]))) as HubConnectionHandler)
}

#Preview("Off") {
    NavigationStack {
        DeviceDetailView(device: .mockPlayer)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
