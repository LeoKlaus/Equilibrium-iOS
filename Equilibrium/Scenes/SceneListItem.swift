//
//  SceneListItem.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 28.06.25.
//

import SwiftUI
import EquilibriumAPI

struct SceneListItem: View {
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    let scene: EquilibriumAPI.Scene
    
    var body: some View {
        HStack {
            VStack {
                /*if connectionHandler.currentSceneStatus?.current_scene == self.scene {
                    Text("Active")
                }*/
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
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
