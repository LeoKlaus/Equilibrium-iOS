//
//  SettingsView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: self.$navigationPath) {
            List {
                NavigationLink {
                    ImageListView()
                } label: {
                    Label("Icons", systemImage: "photo")
                }
                
                NavigationLink {
                    BluetoothDeviceListView()
                } label: {
                    Label("Bluetooth Devices", systemImage: "point.3.connected.trianglepath.dotted")
                }
                
                NavigationLink {
                    CommandListView()
                } label: {
                    Label("Commands", systemImage: "terminal")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
