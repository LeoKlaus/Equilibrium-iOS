//
//  SceneWidgetEntryView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//


import SwiftUI
import EquilibriumAPI
import AppIntents
import WidgetKit

struct SceneWidgetEntryView: View {
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var entry: StatusProvider.Entry
    
    var body: some View {
        VStack {
            if let error = entry.error {
                errorView(error: error)
            } else if let hub = entry.hub {
                VStack {
                    if entry.showControls, let currentScene = entry.status?.currentScene {
                        if widgetFamily == .accessoryRectangular {
                            HStack {
                                VolumeControlGroup(devices: currentScene.devices ?? [], hub: hub)
                                        .widgetAccentable()
                            }
                        } else {
                            HStack {
                                Button(intent: StopSceneIntent(hub: hub)) {
                                    Image(systemName: "power")
                                        .foregroundStyle(Color.red)
                                        .padding(5)
                                        .background {
                                            Circle()
                                                .fill(.gray.opacity(0.1))
                                        }
                                        .widgetAccentable(false)
                                    if let label = currentScene.name {
                                        Text(label)
                                            .foregroundStyle(.secondary)
                                            .font(.footnote)
                                            .widgetAccentable()
                                    }
                                }
                                .buttonStyle(.plain)
                                .frame(maxHeight: 30)
                                Spacer()
                            }
                            VStack {
                                HStack {
                                    VolumeControlGroup(devices: currentScene.devices ?? [], hub: hub)
                                        .widgetAccentable()
                                }
                                TransportControlGroup(devices: currentScene.devices ?? [], hub: hub)
                                    .widgetAccentable()
                            }
                            Spacer()
                        }
                    } else {
                        if widgetFamily == .accessoryRectangular {
                            HStack {
                                ForEach(entry.scenes.prefix(2)) { scene in
                                    Button(intent: StartSceneIntent(hub: hub, scene: scene)) {
                                        Text(String(scene.name?.first ?? "U"))
                                            .font(.title3)
                                            .padding(5)
                                            .background {
                                                Circle()
                                                    .fill(.thickMaterial)
                                            }
                                            .widgetAccentable()
                                    }
                                    .buttonStyle(.plain)
                                    .frame(maxHeight: 60)
                                }
                            }
                        } else {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 95))]) {
                                ForEach(entry.scenes) { scene in
                                    Button(intent: StartSceneIntent(hub: hub, scene: scene)) {
                                        SmallGridItem(scene, isActive: false)
                                    }
                                            .buttonStyle(.plain)
                                            .frame(maxHeight: 60)
                                }
                                //Text(entry.date.formatted(date: .omitted, time: .standard))
                            }
                        }
                    }
                }
            } else {
                errorView(error: "Couldn't get hub, make sure to select a hub in the widget configuration (long press widget).")
            }
            Spacer()
            refreshTime
        }
    }
    
    var refreshTime: some View {
        HStack {
            Spacer()
            Button(intent: ReloadAllWidgetsIntent()) {
                Label {
                    Text(entry.date, style: .time)
                } icon: {
                    Image(systemName: "arrow.clockwise")
                }
                .font(.caption2)
                .foregroundStyle(.secondary)
            }.buttonStyle(.plain)
        }
    }
}

extension SceneWidgetEntryView {
    func errorView(error: String) -> some View {
        VStack {
            Text(error)
                .minimumScaleFactor(0.75)
        }
    }
}

struct CommandButton: View {
    
    let hub: DiscoveredService
    let command: Command
    
    var body: some View {
        Button(intent: SendCommandIntent(hub: hub, command: command)) {
            Image(systemName: command.button.buttonRepresentation.systemImage)
        }.buttonStyle(.plain)
    }
}

struct TransportControlGroup: View {
    
    @Environment(\.widgetFamily) var widgetFamily
    
    let devices: [Device]
    let hub: DiscoveredService
    
    var channelController: Device? {
        self.devices.first(where: { $0.type == .player }) ??
        self.devices.first(where: { $0.type == .display }) ??
        self.devices.first(where: { $0.type == .other })
    }
    
    var body: some View {
        HStack {
            if widgetFamily == .systemMedium || widgetFamily == .systemLarge || widgetFamily == .systemExtraLarge {
                Spacer()
                if let stop = channelController?.commands?.first(where: { $0.button == .stop }) {
                    CommandButton(hub: hub, command: stop)
                        .frame(width: 30, height: 30)
                }
                Spacer()
                if let rewind = channelController?.commands?.first(where: { $0.button == .rewind }) {
                    CommandButton(hub: hub, command: rewind)
                        .frame(width: 30, height: 30)
                }
            }
            Spacer()
            if let play = channelController?.commands?.first(where: { $0.button == .play }) {
                CommandButton(hub: hub, command: play)
                    .frame(width: 30, height: 30)
            }
            Spacer()
            if let pause = channelController?.commands?.first(where: { $0.button == .pause }) {
                CommandButton(hub: hub, command: pause)
                    .frame(width: 30, height: 30)
            }
            Spacer()
            if widgetFamily == .systemMedium || widgetFamily == .systemLarge || widgetFamily == .systemExtraLarge {
                if let fastForward = channelController?.commands?.first(where: { $0.button == .fastForward }) {
                    CommandButton(hub: hub, command: fastForward)
                        .frame(width: 30, height: 30)
                }
                Spacer()
            }
        }.foregroundStyle(.secondary)
    }
}

struct VolumeControlGroup: View {
    
    @Environment(\.widgetFamily) var widgetFamily
    
    let devices: [Device]
    let hub: DiscoveredService
    
    var audioController: Device? {
        devices.first(where: { $0.type == .amplifier }) ??
        devices.first(where: { $0.type == .player }) ??
        devices.first(where: { $0.type == .display }) ??
        devices.first(where: { $0.type == .other })
    }
    
    var channelController: Device? {
        devices.first(where: { $0.type == .player }) ??
        devices.first(where: { $0.type == .display }) ??
        devices.first(where: { $0.type == .other })
    }
    
    var body: some View {
        HStack {
            Spacer()
            if let mute = audioController?.commands?.first(where: { $0.button == .mute }) {
                CommandButton(hub: hub, command: mute)
                    .frame(width: 30, height: 30)
            }
            Spacer()
            if let volDown = audioController?.commands?.first(where: { $0.button == .volumeDown }) {
                CommandButton(hub: hub, command: volDown)
                    .frame(width: 30, height: 30)
            }
            Spacer()
            if let volUp = audioController?.commands?.first(where: { $0.button == .volumeUp }) {
                CommandButton(hub: hub, command: volUp)
                    .frame(width: 30, height: 30)
            }
            Spacer()
            if widgetFamily == .systemMedium || widgetFamily == .systemLarge || widgetFamily == .systemExtraLarge {
                if let chUp = channelController?.commands?.first(where: { $0.button == .channelUp }), let chDown = channelController?.commands?.first(where: { $0.button == .channelDown }) {
                    CommandButton(hub: hub, command: chUp)
                        .frame(width: 30, height: 30)
                    Spacer()
                    CommandButton(hub: hub, command: chDown)
                        .frame(width: 30, height: 30)
                        .offset(y:8)
                    Spacer()
                }
            }
        }
        .foregroundStyle(.secondary)
        .padding(.bottom, 8)
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

#Preview("Medium", as: .systemMedium) {
    SceneControlWidget()
} timeline: {
    // Normal states
    StatusTimelineEntry.mockNoActiveScene
    StatusTimelineEntry.mockActiveScene
    // Error states
    StatusTimelineEntry.mockError
}
