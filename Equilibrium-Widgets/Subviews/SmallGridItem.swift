//
//  SmallGridItem.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import SwiftUI
import EquilibriumAPI
import WidgetKit

struct SmallGridItem: View {
    
    @Environment(\.widgetRenderingMode) var widgetRenderingMode
    
    let scene: EquilibriumAPI.Scene
    var isActive: Bool = false
    
    init(_ scene: EquilibriumAPI.Scene, isActive: Bool = false) {
        self.scene = scene
        self.isActive = isActive
    }
    
    var body: some View {
        HStack {
            Text(String(scene.name?.first ?? "U"))
                .font(.title)
                .background {
                    Circle()
                        .fill(.gray.opacity(0.1))
                        .frame(width: 50, height: 50)
                }
                .widgetAccentable()
                .frame(maxWidth: 60, maxHeight: 60)
            
            Text(scene.name ?? "Unnamed Scene")
                .widgetAccentable()
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .foregroundColor(isActive ? .accentColor : .primary)
        .padding(10)
        .frame(maxWidth: .infinity)
        /*.if(widgetRenderingMode == .accented) { view in
            view.background(Color.gray.opacity(0.1))
        }
        .if(widgetRenderingMode != .accented) { view in
            view.background(.thinMaterial)
        }*/
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}

#Preview("Small", as: .systemSmall) {
    SceneControlWidget()
} timeline: {
    // Normal states
    StatusTimelineEntry.mockNoActiveScene
    StatusTimelineEntry.mockActiveScene
    // Error states
    StatusTimelineEntry.mockError
}
