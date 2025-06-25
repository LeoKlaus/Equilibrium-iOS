//
//  DeviceCreationView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 24.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct DeviceCreationView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    enum Page {
        case basicDetails
        case commands
        case save
    }
    
    @State private var currentPage: Page = .basicDetails
    
    var body: some View {
        switch currentPage {
        case .basicDetails:
            basicDetails
        case .commands:
            commands
        case .save:
            save
        }
    }
    
    var basicDetails: some View {
        Text("basic")
    }
    
    var commands: some View {
        Text("commands")
    }
    
    var save: some View {
        Text("save")
    }
}


#Preview {
    DeviceCreationView()
        .withErrorHandling()
        .environment(HubConnectionHandler())
}
