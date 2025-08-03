//
//  SceneListItem.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 28.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct SceneListItem: View {
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    let scene: EquilibriumAPI.Scene
    
    func startScene(scene: EquilibriumAPI.Scene) {
        guard let sceneId = scene.id else {
            self.errorHandler.handle("\(scene.name ?? "Scene") has no id", while: "starting scene")
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
        HStack {
            VStack {
                if let status = self.connectionHandler.currentSceneStatus, status.currentScene == self.scene {
                        switch status.sceneStatus {
                        case .active:
                            Button(action: self.stopScene) {
                                Image(systemName: "stop.fill")
                                    .foregroundStyle(.red)
                                    .background {
                                        Circle()
                                            .fill(.thickMaterial)
                                            .frame(width: 50, height: 50)
                                    }
                            }
                        default:
                            ProgressView()
                    }
                } else {
                    Button {
                        self.startScene(scene: scene)
                    } label: {
                        if let image = scene.image {
                            ImageView(image: image)
                        } else {
                            Text(String(scene.name?.first ?? "U"))
                                .font(.title)
                                .background {
                                    Circle()
                                        .fill(.thickMaterial)
                                        .frame(width: 50, height: 50)
                                }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(scene.name ?? "Unnamed Scene")
                    .font(.title3)
                    .bold()
                Text((scene.devices?.map(\.name) ?? []).joined(separator: " - "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
            }
            Spacer()
        }
    }
}

#Preview {
    List {
        SceneListItem(scene: .mock)
        SceneListItem(scene: Scene(id: 2, name: "Play PS5", devices: [
            .mockTV,
            .mockAmplifier
        ]))
    }
    .environment(MockHubConnectionHandler(sceneStatus: StatusReport(current_scene: .mock, scene_status: .active)) as HubConnectionHandler)
    .withErrorHandling()
}

#Preview("Starting") {
    List {
        SceneListItem(scene: .mock)
        SceneListItem(scene: Scene(id: 2, name: "Play PS5", devices: [
            .mockTV,
            .mockAmplifier
        ]))
    }
    .environment(MockHubConnectionHandler(sceneStatus: StatusReport(current_scene: .mock, scene_status: .starting)) as HubConnectionHandler)
    .withErrorHandling()
}
