//
//  ScenesView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct ScenesView: View {
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State private var navigationPath = NavigationPath()
    
    @State private var isLoading: Bool = true
    
    @State private var showSceneCreationSheet: Bool = false
    
    @Sendable
    func getScenes() async {
        self.isLoading = true
        do {
            _ = try await self.connectionHandler.getScenes()
        } catch {
            self.errorHandler.handle(error, while: "getting scenes from hub")
        }
        self.isLoading = false
    }
    
    
    func startScene(scene: EquilibriumAPI.Scene) {
        guard let sceneId = scene.id else {
            self.errorHandler.handle("Scene \(scene.name ?? "") has no ID", while: "starting scene")
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
    
    var body: some View {
        NavigationStack(path: self.$navigationPath) {
            List {
                if connectionHandler.scenes.isEmpty {
                    if isLoading {
                        Label {
                            Text("Loading scenes...")
                        } icon: {
                            ProgressView()
                        }
                    } else {
                        Text("No scenes found.")
                        Button {
                            self.showSceneCreationSheet = true
                        } label: {
                            Label("Create one now?", systemImage: "plus")
                        }
                    }
                }
                ForEach(connectionHandler.scenes) { scene in
                    NavigationLink(destination: SceneDetailView(scene: scene)) {
                        SceneListItem(scene: scene)
                    }
                    .contextMenu {
                        if connectionHandler.currentSceneStatus?.current_scene == scene {
                            Button(role: .destructive, action: self.stopScene) {
                                Label("Stop \(scene.name ?? "Scene")", systemImage: "poweroff")
                            }
                        } else {
                            Button {
                                self.startScene(scene: scene)
                            } label: {
                                Label("Start \(scene.name ?? "Scene")", systemImage: "togglepower")
                            }
                        }
                        Divider()
                        NavigationLink(destination: CreateSceneView(scene: scene)) {
                            Label("Edit \(scene.name ?? "Scene")", systemImage: "pencil")
                        }
                    }
                }
            }
            .navigationTitle("Scenes")
            .task(self.getScenes)
            .refreshable(action: self.getScenes)
            .sheet(isPresented: $showSceneCreationSheet) {
                NavigationStack {
                    CreateSceneView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        self.showSceneCreationSheet = true
                    } label: {
                        Label("Add Scene", systemImage: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    ScenesView()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
        .withErrorHandling()
}
