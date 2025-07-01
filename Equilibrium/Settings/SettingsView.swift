//
//  SettingsView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var navigationPath = NavigationPath()
    
    @AppStorage(UserDefaultKey.invertImagesInDarkMode.rawValue, store: UserDefaults(suiteName: "group.me.wehrfritz.Equilibrium")) var invertImagesInDarkMode: Bool = true
    
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
                
                NavigationLink {
                    MacroListView()
                } label: {
                    Label("Macros", systemImage: "command")
                }
                
                Section {
                    Toggle("Invert Images in Dark Mode", isOn: $invertImagesInDarkMode)
                } footer: {
                    Text("Inverts all images for scenes and devices while in dark mode (especially useful for black & white icons).")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
