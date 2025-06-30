//
//  EquilibriumApp.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 19.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

@main
struct EquilibriumApp: App {
    
    
    
    @AppStorage(UserDefaultKey.connectedHubs.rawValue, store: UserDefaults(suiteName: "group.me.wehrfritz.Equilibrium")) var connectedHubs: [DiscoveredService] = []
    
    let connectionHandler = HubConnectionHandler()
    
    var body: some SwiftUI.Scene {
        WindowGroup {
            VStack {
                if connectedHubs.isEmpty {
                    DiscoverHubsView()
                } else {
                    ContentView()
                }
            }
            .withErrorHandling()
            .environment(self.connectionHandler)
        }
    }
}
