//
//  ScenesView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import SwiftUI

struct ScenesView: View {
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: self.$navigationPath) {
            ScrollView {
                if connectionHandler.scenes.isEmpty {
                    Text("You don't have any scenes yet, do you want to create one?")
                }
                ForEach(connectionHandler.scenes) { scene in
                    // TODO: Implement scene buttons
                }
            }
        }
    }
}

#Preview {
    ScenesView()
        .environment(HubConnectionHandler())
}
