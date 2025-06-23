//
//  EquilibriumApp.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 19.06.25.
//

import SwiftUI
import EasyErrorHandling

@main
struct EquilibriumApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withErrorHandling()
        }
    }
}
