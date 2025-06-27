//
//  ContentView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 19.06.25.
//

import SwiftUI
import EasyErrorHandling

struct ContentView: View {
    
    var body: some View {
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
                if false {
                    Text("Hello")
                }
            }
            .tabBarMinimizeBehavior(.onScrollDown)
        } else {
            TabView {
                
                ScenesView()
                    .tabItem {
                        Label("Scenes", systemImage: "tv")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
        .withErrorHandling()
}
