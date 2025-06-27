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
    
    @State private var isSaving: Bool = false
    @State private var showCommandCreation: Bool = false
    
    @State private var createdDevice: Device? = nil
    
    func saveDevice() {
        self.isSaving = true
        
        var manufacturerStr: String? = nil
        var modelStr: String? = nil
        
        if !self.manufacturer.isEmpty {
            manufacturerStr = self.manufacturer
        }
        if !self.model.isEmpty {
            modelStr = self.model
        }
        
        let device = Device(name: self.name, manufacturer: manufacturerStr, model: modelStr, type: self.type, imageId: self.image?.id)
        
        Task {
            do {
                self.createdDevice = try await self.connectionHandler.createDevice(device)
                self.showCommandCreation = true
            } catch {
                self.errorHandler.handle(error, while: "saving device")
            }
            self.isSaving = false
        }
    }
    
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
            
            Section {
                Button(action: saveDevice) {
                    if isSaving {
                        HStack {
                            ProgressView()
                            Text("Saving device...")
                        }
                    } else {
                        Label("Add commands", systemImage: "terminal")
                    }
                }
                .disabled(isSaving)
            }
            .navigationDestination(isPresented: $showCommandCreation) {
                if let createdDevice {
                    DeviceCommandAssistant(device: createdDevice)
                } else {
                    Text("Couldn't get the newly created device from the hub. Please try adding commands again.")
                }
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
