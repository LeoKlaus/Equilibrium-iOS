//
//  CreateCommandView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct CreateCommandView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @State private var name: String = ""
    @State private var button: RemoteButton = .other
    @State private var type: CommandType = .ir
    @State private var device: Device? = nil
    @State private var commandGroup: EquilibriumAPI.CommandGroup? = nil
    
    // Network command only
    @State private var host: String = ""
    @State private var method: HTTPMethod = .get
    @State private var requestBody: String = ""
    
    // Bluetooth command only
    @State private var btActionType: BluetoothActionType = .regularKey
    @State private var btAction: CommonBluetoothKey = .up
    @State private var btMediaAction: BluetoothMediaKey = .play
    @State private var otherBtAction: String = ""
    
    @Sendable func getDevices() async {
        do {
            _ = try await self.connectionHandler.getDevices()
        } catch {
            self.errorHandler.handle(error, while: "loading devices")
        }
    }
    
    func createCommand() {
        var btActionStr: String? = nil
        var btMediaActionStr: String? = nil
        
        var networkHost: String? = nil
        var networkMethod: HTTPMethod? = nil
        var networkBody: String? = nil
        
        switch self.type {
        case .ir:
            return
        case .bluetooth:
            switch self.btActionType {
            case .regularKey:
                if self.btAction == .other {
                    btActionStr = self.otherBtAction
                } else {
                    btActionStr = self.btAction.rawValue
                }
            case .mediaKey:
                btMediaActionStr = self.btMediaAction.rawValue
            }
        case .network:
            networkHost = self.host
            networkMethod = self.method
            if networkMethod == .post || networkMethod == .patch || networkMethod == .put {
                networkBody = self.requestBody
            }
        case .script:
            // TODO: Implement
            break
        }
        
        let newCommand = Command(
            name: self.name,
            button: self.button,
            type: self.type,
            commandGroupId: self.commandGroup?.id,
            host: networkHost,
            method: networkMethod,
            body: networkBody,
            btAction: btActionStr,
            btMediaAction: btMediaActionStr
        )
        
        Task {
            do {
                _ = try await connectionHandler.createCommand(newCommand)
                self.dismiss()
            } catch {
                self.errorHandler.handle(error, while: "creating command")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Name", text: $name)
                    Picker("Device", selection: $device) {
                        ForEach(self.connectionHandler.devices) { device in
                            Text(device.name).tag(device)
                        }
                        Text("None").tag(nil as Device?)
                    }
                    .pickerStyle(.navigationLink)
                    if let device {
                        Picker("Command group", selection: $commandGroup) {
                            ForEach(device.commandGroups ?? []) { commandGroup in
                                Text(commandGroup.name).tag(commandGroup)
                            }
                            Divider()
                            Text("None").tag(nil as EquilibriumAPI.CommandGroup?)
                        }
                    }
                    Picker("Type", selection: $type) {
                        Text("Infrared").tag(CommandType.ir)
                        Text("Bluetooth").tag(CommandType.bluetooth)
                        Text("Network request").tag(CommandType.network)
                        Text("Script").tag(CommandType.script)
                    }
                    NavigationLink(destination: RemoteButtonPicker(button: $button, category: commandGroup?.type)) {
                        HStack {
                            Text("Button")
                            Spacer()
                            Text(button.buttonRepresentation.name)
                                .foregroundStyle(.secondary)
                        }
                    }
                } footer: {
                    Text("Setting the correct button allows Equilibrium to automatically suggest key maps for scenes.")
                }
                
                if type == .ir {
                    Section("Infrared Command") {
                        IrCommandCreationView(
                            command: Command(
                                name: self.name,
                                button: self.button,
                                type: self.type,
                                commandGroupId: self.commandGroup?.id
                            ),
                            afterFinish:  {
                                dismiss()
                            }
                        )
                    }
                }
                
                if type == .bluetooth {
                    bluetoothSection
                }
                
                
                if type == .network {
                    networkSection
                }
                
                if type == .script {
                    scriptSection
                }
                
                if type != .ir && type != .script {
                    Button(action: self.createCommand) {
                        Label("Save", systemImage: "square.and.arrow.down")
                    }
                }
            }
        }
        .task(getDevices)
    }
    
    var bluetoothSection: some View {
        Section("Bluetooth Command") {
            Picker("Type", selection: $btActionType) {
                ForEach(BluetoothActionType.allCases, id: \.hashValue) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            switch btActionType {
            case .regularKey:
                Picker("Key", selection: $btAction) {
                    ForEach(CommonBluetoothKey.allCases, id: \.rawValue) { key in
                        Text(key.localizedName).tag(key)
                    }
                }
            case .mediaKey:
                Picker("Media Key", selection: $btMediaAction) {
                    ForEach(BluetoothMediaKey.allCases, id: \.rawValue) { key in
                        Text(key.localizedName).tag(key)
                    }
                }
            }
            if btActionType == .regularKey && btAction == .other {
                TextField("KEY_CODE", text: $otherBtAction)
                    .autocorrectionDisabled()
                    .textCase(.uppercase)
            }
        }
    }
    
    var networkSection: some View {
        Section("Network Command") {
            TextField("Host", text: $host)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.URL)
            Picker("Type", selection: $method) {
                Text("GET").tag(HTTPMethod.get)
                Text("POST").tag(HTTPMethod.post)
                Text("PATCH").tag(HTTPMethod.patch)
                Text("DELETE").tag(HTTPMethod.delete)
                Text("HEAD").tag(HTTPMethod.head)
                Text("PUT").tag(HTTPMethod.put)
            }
            if method == .post || method == .patch || method == .put {
                TextEditor(text: $requestBody)
                    .font(.system(size: 14, design: .monospaced))
                    .overlay(alignment: .leading) {
                        if requestBody.isEmpty {
                            Text("Body")
                                .padding(.leading, 3)
                                .padding(.top, 3)
                                .opacity(0.25)
                        }
                    }
            }
        }
    }
    
    var scriptSection: some View {
        Section("Script Command") {
            Text("Creating script commands is currently not supported")
        }
    }
}

#Preview {
    CreateCommandView()
        .withErrorHandling()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
