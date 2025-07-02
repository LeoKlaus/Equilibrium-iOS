//
//  ContentView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 19.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct ContentView: View {
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    func connectToStatusSocket() {
        Task {
            do {
                try await self.connectionHandler.connectToStatusWebsocket()
            } catch {
                self.errorHandler.handle(error, while: "connecting to status socket")
            }
        }
    }
    
    func disconnectFromStatusSocket() {
        Task {
            do {
                try await self.connectionHandler.closeStatusWebsocket()
            } catch {
                self.errorHandler.handle(error, while: "disconnecting from status socket")
            }
        }
    }
    
    var body: some View {
        VStack {
            if #available(iOS 26.0, macOS 26.0, *) {
                TabView {
                    Tab("Scenes", systemImage: "tv") {
                        ScenesView()
                    }
                    Tab("Devices", systemImage: "cpu") {
                        DevicesView()
                    }
                    Tab("Settings", systemImage: "gear") {
                        SettingsView()
                    }
                }
                .tabViewBottomAccessory {
                    CurrentSceneQuickSettings()
                }
            } else {
                TabView {
                    ScenesView()
                        .tabItem {
                            Label("Scenes", systemImage: "tv")
                        }
                    
                    DevicesView()
                        .tabItem {
                            Label("Devices", systemImage: "cpu")
                        }
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                }
                .overlay(alignment: .bottom) {
                    CurrentSceneQuickSettings()
                }
            }
        }
        .onAppear(perform: self.connectToStatusSocket)
        .onDisappear(perform: self.disconnectFromStatusSocket)
    }
}

#Preview {
    ContentView()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
        .withErrorHandling()
}
