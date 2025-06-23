//
//  ContentView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 19.06.25.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("connectedHubs", store: UserDefaults(suiteName: "group.me.wehrfritz.Equilibrium")) var connectedHubs: [DiscoveredService] = []
    
    var body: some View {
        if connectedHubs.isEmpty {
            DiscoverHubsView()
        } else {
            if #available(iOS 26.0, macOS 26.0, *) {
                TabView {
                    Tab("Scenes", systemImage: "tv") {
                        
                    }
                    Tab("Devices", systemImage: "cpu") {
                        Text(verbatim: "devices")
                    }
                    Tab("Settings", systemImage: "gear") {
                        Text(verbatim: "settings")
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
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
