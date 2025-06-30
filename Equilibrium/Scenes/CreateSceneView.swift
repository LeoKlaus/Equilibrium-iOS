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
    
    //@State private var keymap: String? = nil
    
    init(scene: EquilibriumAPI.Scene) {
        self.isEditView = true
        self.id = scene.id
        
        self._name = State(initialValue: scene.name ?? "")
        self._image = State(initialValue: scene.image)
        self._bluetoothAddress = State(initialValue: scene.bluetoothAddress)
        self._startMacro = State(initialValue: scene.startMacro)
        self._stopMacro = State(initialValue: scene.stopMacro)
        
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
        
        //let scene = EquilibriumAPI.Scene(id: self.id, name: self.name, imageId: self.image?.id, bluetoothAddress: self.bleDevice?.address ?? self.bluetoothAddress, keymap: self.keymap, startMacroId: self.startMacro?.id, stopMacroId: self.stopMacro?.id)
        let scene = EquilibriumAPI.Scene(id: self.id, name: self.name, imageId: self.image?.id, bluetoothAddress: self.bleDevice?.address ?? self.bluetoothAddress, startMacroId: self.startMacro?.id, stopMacroId: self.stopMacro?.id)
        
        
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
                Picker("Start Macro", selection: $startMacro) {
                    ForEach(self.macros) { macro in
                        Text(macro.name ?? "Macro \(macro.id ?? 0)").tag(macro)
                    }
                    Divider()
                    Text("None").tag(nil as Macro?)
                }
                Picker("Stop Macro", selection: $stopMacro) {
                    ForEach(self.macros) { macro in
                        Text(macro.name ?? "Macro \(macro.id ?? 0)").tag(macro)
                    }
                    Divider()
                    Text("None").tag(nil as Macro?)
                }
            } header: {
                Text("Macros")
            } footer: {
                Text("These macros will run every time the scene is started or stopped. You should use these to turn on and off devices and change inputs as needed.")
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
