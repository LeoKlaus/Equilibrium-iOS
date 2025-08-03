//
//  SceneDetailView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 29.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling
import AVFAudio

struct SceneDetailView: View {
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State var scene: EquilibriumAPI.Scene
    
    @Sendable
    func getScene() async {
        guard let sceneId = self.scene.id else {
            self.errorHandler.handle("\(scene.name ?? "scene") has no id", while: "getting scene details from hub")
            return
        }
        do {
            self.scene = try await self.connectionHandler.getScene(sceneId)
        } catch {
            self.errorHandler.handle(error, while: "getting scene details from hub")
        }
    }
    
    func startScene() {
        guard let sceneId = self.scene.id else {
            self.errorHandler.handle("\(scene.name ?? "scene") has no id", while: "starting scene")
            return
        }
        Task {
            do {
                try await self.connectionHandler.startScene(sceneId)
            } catch {
                self.errorHandler.handle(error, while: "starting scene")
            }
        }
    }
    
    func stopScene() {
        Task {
            do {
                try await self.connectionHandler.stopCurrentScene()
            } catch {
                self.errorHandler.handle(error, while: "stopping scene")
            }
        }
    }
    
    func sendMacro(_ macro: Macro) {
        guard let macroId = macro.id else {
            self.errorHandler.handle("\(macro.name ?? "Macro") has no id", while: "executing macro")
            return
        }
        Task {
            do {
                try await self.connectionHandler.sendMacro(macroId)
            } catch {
                self.errorHandler.handle(error, while: "executing macro")
            }
        }
    }
    
    var body: some View {
        TabView {
            CommonControlsView(devices: scene.devices ?? [])
                .tabItem{
                    Label("Common Controls", systemImage: "dpad.fill")
                }
            NumberControlGroup(devices: scene.devices ?? [])
                .tabItem{
                    Label("Numeric Controls", systemImage: "numbers.rectangle")
                }
            OtherControlGroup(devices: scene.devices ?? [])
                .tabItem{
                    Label("Numeric Controls", systemImage: "ellipsis")
                }
        }
        .task(self.getScene)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationTitle(scene.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            
            if !(self.scene.macros?.isEmpty ?? true) {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        ForEach(self.scene.macros ?? []) { macro in
                            Button(macro.name ?? "Unnamed Macro") {
                                self.sendMacro(macro)
                            }
                        }
                    } label: {
                        Label("Macros", systemImage: "command")
                    }
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                if connectionHandler.currentSceneStatus?.sceneStatus == .starting || connectionHandler.currentSceneStatus?.sceneStatus == .stopping {
                    ProgressView()
                } else if connectionHandler.currentSceneStatus?.currentScene == scene {
                    Button(role: .destructive, action: self.stopScene) {
                        Image(systemName: "power.circle.fill")
                            .foregroundStyle(.red)
                    }
                    .accessibilityHint(Text("Stop \(scene.name ?? "scene")"))
                } else {
                    Button(action: self.startScene) {
                        Image(systemName: "power.circle")
                            .foregroundStyle(.green)
                    }
                    .accessibilityHint(Text("Start \(scene.name ?? "scene")"))
                }
            }
        }
    }
}

#Preview("Active") {
    NavigationStack {
        SceneDetailView(scene: .mock)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler(sceneStatus: StatusReport(current_scene: .mock, scene_status: .active)) as HubConnectionHandler)
}

#Preview("Inactive") {
    NavigationStack {
        SceneDetailView(scene: .mock)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler(sceneStatus: StatusReport(current_scene: nil, scene_status: nil)) as HubConnectionHandler)
}

#Preview("Starting") {
    NavigationStack {
        SceneDetailView(scene: .mock)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler(sceneStatus: StatusReport(current_scene: .mock, scene_status: .starting)) as HubConnectionHandler)
}
