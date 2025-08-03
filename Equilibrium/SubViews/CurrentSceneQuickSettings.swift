//
//  CurrentSceneQuickSettings.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 29.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct CurrentSceneQuickSettings: View {
    
    //@Environment(\.tabViewBottomAccessoryPlacement) var placement
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State private var showSceneSheet: Bool = false
    
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
        if let scene = connectionHandler.currentSceneStatus?.currentScene {
            switch connectionHandler.currentSceneStatus?.sceneStatus {
            case .starting:
                HStack {
                    Spacer()
                    ProgressView()
                    Text("Starting \(scene.name ?? "scene")...")
                    Spacer()
                }
            case .stopping:
                HStack {
                    Spacer()
                    ProgressView()
                    Text("Stopping \(scene.name ?? "scene")...")
                    Spacer()
                }
            default:
                HStack {
                    if let image = scene.image {
                        ImageView(image: image)
                    }
                    if let name = scene.name {
                        Text(name)
                    }
                    Spacer()
                    Button(action: self.stopScene) {
                        Label("Stop \(scene.name ?? "scene")", systemImage: "power").foregroundStyle(.red)
                    }
                }
                .contentShape(.rect)
                .padding(.horizontal)
                .onTapGesture {
                    self.showSceneSheet.toggle()
                }
                .sheet(isPresented: $showSceneSheet) {
                    SceneDetailView(scene: scene)
                }
            }
        }
    }
}

@available(iOS 26.0, macOS 26.0, *)
#Preview("No Scene") {
    TabView {
        Tab("Scenes", systemImage: "tv") {
            List {
                Text(verbatim: "Placeholder")
            }
        }
    }
    .tabBarMinimizeBehavior(.onScrollDown)
    .tabViewBottomAccessory {
        CurrentSceneQuickSettings()
    }
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}

@available(iOS 26.0, macOS 26.0, *)
#Preview("Starting scene") {
    TabView {
        Tab("Scenes", systemImage: "tv") {
            List {
                Text(verbatim: "Placeholder")
            }
        }
    }
    .tabBarMinimizeBehavior(.onScrollDown)
    .tabViewBottomAccessory {
        CurrentSceneQuickSettings()
    }
    .environment(MockHubConnectionHandler(sceneStatus: StatusReport(current_scene: .mock, scene_status: .starting, devices: nil)) as HubConnectionHandler)
}

@available(iOS 26.0, macOS 26.0, *)
#Preview("Stopping scene") {
    TabView {
        Tab("Scenes", systemImage: "tv") {
            List {
                Text(verbatim: "Placeholder")
            }
        }
    }
    .tabBarMinimizeBehavior(.onScrollDown)
    .tabViewBottomAccessory {
        CurrentSceneQuickSettings()
    }
    .environment(MockHubConnectionHandler(sceneStatus: StatusReport(current_scene: .mock, scene_status: .stopping, devices: nil)) as HubConnectionHandler)
}

@available(iOS 26.0, macOS 26.0, *)
#Preview("Scene active") {
    TabView {
        Tab("Scenes", systemImage: "tv") {
            List {
                Text(verbatim: "Placeholder")
            }
        }
    }
    .tabBarMinimizeBehavior(.onScrollDown)
    .tabViewBottomAccessory {
        CurrentSceneQuickSettings()
    }
    .environment(MockHubConnectionHandler(sceneStatus: StatusReport(current_scene: .mock, scene_status: .active, devices: nil)) as HubConnectionHandler)
}
