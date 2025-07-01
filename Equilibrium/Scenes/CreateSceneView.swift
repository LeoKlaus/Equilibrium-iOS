//
//  CreateSceneView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 28.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct CreateSceneView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    let isEditView: Bool
    let id: Int?
    
    @State private var isSaving: Bool = false
    @State private var macros: [Macro] = []
    
    @State private var createdScene: EquilibriumAPI.Scene? = nil
    
    @State private var name: String = ""
    @State private var image: UserImage? = nil
    
    @State private var bleDevice: BleDevice? = nil
    @State private var bluetoothAddress: String? = nil
    
    @State private var startMacro: Macro? = nil
    @State private var stopMacro: Macro? = nil
    
    @State private var devices: [Device] = []
    
    //@State private var keymap: String? = nil
    
    init(scene: EquilibriumAPI.Scene) {
        self.isEditView = true
        self.id = scene.id
        
        self._name = State(initialValue: scene.name ?? "")
        self._image = State(initialValue: scene.image)
        self._bluetoothAddress = State(initialValue: scene.bluetoothAddress)
        self._startMacro = State(initialValue: scene.startMacro)
        self._stopMacro = State(initialValue: scene.stopMacro)
        
        self._devices = State(initialValue: scene.devices ?? [])
        
        //self._keymap = State(initialValue: scene.keymap)
    }
    
    init() {
        self.isEditView = false
        self.id = nil
    }
    
    @Sendable
    func getMacros() async {
        do {
            self.macros = try await self.connectionHandler.getMacros()
        } catch {
            self.errorHandler.handle(error, while: "getting macros from hub")
        }
    }
    
    func saveScene() {
        self.isSaving = true
        
        //let scene = EquilibriumAPI.Scene(id: self.id, name: self.name, imageId: self.image?.id, bluetoothAddress: self.bleDevice?.address ?? self.bluetoothAddress, keymap: self.keymap, deviceIds: self.devices.compactMap(\.id), startMacroId: self.startMacro?.id, stopMacroId: self.stopMacro?.id)
        let scene = EquilibriumAPI.Scene(id: self.id, name: self.name, imageId: self.image?.id, bluetoothAddress: self.bleDevice?.address ?? self.bluetoothAddress, deviceIds: self.devices.compactMap(\.id), startMacroId: self.startMacro?.id, stopMacroId: self.stopMacro?.id)
        
        
        Task {
            do {
                if isEditView {
                    _ = try await self.connectionHandler.updateScene(scene)
                    self.dismiss()
                } else {
                    self.createdScene = try await self.connectionHandler.createScene(scene)
                }
            } catch {
                self.errorHandler.handle(error, while: "saving scene")
            }
            self.isSaving = false
        }
    }
    
    var body: some View {
        List {
            TextField("Name", text: $name)
            
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
                NavigationLink(destination: MacroListView(selectedMacro: self.$startMacro)) {
                    HStack {
                        Text("Start Macro")
                        Spacer()
                        if let startMacro {
                            Text(startMacro.name ?? "Unnamed Macro")
                                .foregroundStyle(.secondary)
                        } else {
                            Text("None")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                NavigationLink(destination: MacroListView(selectedMacro: self.$stopMacro)) {
                    HStack {
                        Text("Stop Macro")
                        Spacer()
                        if let stopMacro {
                            Text(stopMacro.name ?? "Unnamed Macro")
                                .foregroundStyle(.secondary)
                        } else {
                            Text("None")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } header: {
                Text("Macros")
            } footer: {
                Text("These macros will run every time the scene is started or stopped. You should use these to turn on and off devices and change inputs as needed.")
            }
            
            Section {
                NavigationLink(destination: DevicesPicker(selectedDevices: self.$devices)) {
                    HStack {
                        Text("Devices")
                        Spacer()
                        if devices.isEmpty {
                            Text("None")
                                .foregroundStyle(.secondary)
                        } else if devices.count == 1, let deviceName = devices.first?.name {
                            Text(deviceName)
                                .foregroundStyle(.secondary)
                        } else {
                            Text(String(devices.count))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } header: {
                Text("Devices")
            } footer: {
                Text("All devices included in either start or stop macro and the associated bluetooth device (if applicable) will be added automatically. You can still manually add devices to this scene.")
            }
            
            /*Section {
                Picker("Keymap", selection: $keymap) {
                    // TODO: Implement keymap selection
                    Text("None").tag(nil as String?)
                }
            } footer: {
                Text("Determines which remote buttons send which commands to your devices. Equilibrium can suggest a keymap based on the devices associated with this scene.")
            }*/
            
            Button(action: self.saveScene) {
                if isSaving {
                    HStack {
                        ProgressView()
                        Text("Saving scene...")
                    }
                } else {
                    if isEditView {
                        Label("Save Changes", systemImage: "square.and.arrow.down")
                    } else {
                        Label("Save Scene", systemImage: "terminal")
                    }
                }
            }
            .disabled(isSaving)
        }
        .task(self.getMacros)
    }
}

#Preview("Create") {
    NavigationStack {
        CreateSceneView()
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}

#Preview("Edit") {
    NavigationStack {
        CreateSceneView(scene: .mock)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
