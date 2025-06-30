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
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    let isEditView: Bool
    let id: Int?
    
    @State private var name: String = ""
    @State private var manufacturer: String = ""
    @State private var model: String = ""
    @State private var type: DeviceType = .other
    
    @State private var image: UserImage? = nil
    
    @State private var bleDevice: BleDevice? = nil
    @State private var bluetoothAddress: String? = nil
    
    @State private var isSaving: Bool = false
    
    @State private var createdDevice: Device? = nil
    
    init() {
        self.isEditView = false
        self.id = nil
    }
    
    init(device: Device) {
        self.isEditView = true
        
        self.id = device.id
        
        self._name = State(initialValue: device.name)
        self._manufacturer = State(initialValue: device.manufacturer ?? "")
        self._model = State(initialValue: device.model ?? "")
        self._type = State(initialValue: device.type)
        
        self._image = State(initialValue: device.image)
        
        // TODO: Get matching bluetooth device
        //self._bleDevice = State(initialValue: device.bluetoothAddress ?? "")
        self._bluetoothAddress = State(initialValue: device.bluetoothAddress)
    }
    
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
        
        
        let device = Device(id: self.id, name: self.name, manufacturer: manufacturerStr, model: modelStr, type: self.type, bluetoothAddress: self.bleDevice?.address ?? self.bluetoothAddress, imageId: self.image?.id)
        
        Task {
            do {
                if isEditView {
                    _ = try await self.connectionHandler.updateDevice(device)
                    self.dismiss()
                } else {
                    self.createdDevice = try await self.connectionHandler.createDevice(device)
                }
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
                NavigationLink {
                    BluetoothDeviceListView(selectedDevice: self.$bleDevice)
                        .onDisappear {
                            self.bluetoothAddress = nil
                        }
                } label: {
                    HStack {
                        Text("Device")
                        Spacer()
                        Text(self.bleDevice?.name ?? self.bluetoothAddress ?? "None")
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Bluetooth Device")
            } footer: {
                Text("If this device can be controlled with a bluetooth keyboard (like an Apple TV), Equilibrium can connect to it that way.")
            }
            
            Section {
                Button(action: self.saveDevice) {
                    if isSaving {
                        HStack {
                            ProgressView()
                            Text("Saving device...")
                        }
                    } else {
                        if isEditView {
                            Label("Save changes", systemImage: "square.and.arrow.down")
                        } else {
                            Label("Add commands", systemImage: "terminal")
                        }
                    }
                }
                .disabled(isSaving)
            }
            .navigationDestination(item: $createdDevice) { device in
                DeviceCommandAssistant(device: device)
            }
        }
    }
}

#Preview("Create") {
    NavigationStack {
        BasicDeviceCreationView()
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}

#Preview("Update") {
    NavigationStack {
        BasicDeviceCreationView(device: .mockTV)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
