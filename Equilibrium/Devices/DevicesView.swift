//
//  DevicesView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import SwiftUI
import EasyErrorHandling

struct DevicesView: View {
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: self.$navigationPath) {
            DeviceListView()
        }
    }
}

#Preview {
    DevicesView()
        .withErrorHandling()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
