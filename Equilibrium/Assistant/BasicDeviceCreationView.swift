//
//  BasicDeviceCreationView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct BasicDeviceCreationView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @State private var name: String = ""
    @State private var manufacturer: String = ""
    @State private var model: String = ""
    @State private var type: DeviceType = .other
    
    @State private var image: UserImage? = nil
    
    @State private var bleDevice: BleDevice? = nil
    
    var body: some View {
        List {
            Section {
                TextField("Name", text: $name)
                TextField("Manufacturer", text: $manufacturer)
                TextField("Model", text: $model)
                Picker("Type", selection: $type) {
                    ForEach(DeviceType.allCases) { type in
                        Text(type.name).tag(type)
                    }
                }
            } footer: {
                Text("Select the type that best fits your device. This information will be used to automatically suggest key maps for your remote.")
            }
            
            Section("Image") {
                NavigationLink(destination: ImageListView(selectedImage: $image)) {
                    HStack {
                        Text("Image")
                        Spacer()
                        Text(self.image?.filename ?? "None")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Section {
                NavigationLink(destination: BluetoothDeviceListView(selectedDevice: self.$bleDevice)) {
                    HStack {
                        Text("Device")
                        Spacer()
                        Text(self.bleDevice?.name ?? "None")
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Bluetooth Device")
            } footer: {
                Text("If this device can be controlled with a bluetooth keyboard (like an Apple TV), Equilibrium can connect to it that way.")
            }
        }
    }
}

#Preview {
    NavigationStack {
        BasicDeviceCreationView()
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
