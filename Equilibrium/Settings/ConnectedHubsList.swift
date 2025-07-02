//
//  ConnectedHubsList.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 02.07.25.
//

import SwiftUI
import EasyErrorHandling

struct ConnectedHubsList: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(HubConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @AppStorage(UserDefaultKey.connectedHubs.rawValue, store: UserDefaults(suiteName: "group.me.wehrfritz.Equilibrium")) var connectedHubs: [DiscoveredService] = []
    
    @AppStorage(UserDefaultKey.currentHub.rawValue, store: UserDefaults(suiteName: "group.me.wehrfritz.Equilibrium")) var currentHub: DiscoveredService? = nil
    
    var body: some View {
        List {
            if self.connectedHubs.isEmpty {
                Text("No hubs connected.")
            }
            ForEach(connectedHubs) { hub in
                Menu {
                    if hub != self.currentHub {
                        Button("Switch to \(hub.name)") {
                            do {
                                try self.connectionHandler.switchToHub(hub)
                                self.dismiss()
                            } catch {
                                self.errorHandler.handle(error, while: "switching hub")
                            }
                        }
                        Divider()
                    }
                    Button(role: .destructive) {
                        if self.currentHub == hub {
                            if let nextHub = self.connectedHubs.first(where: { $0 != hub }) {
                                do {
                                    try self.connectionHandler.switchToHub(nextHub)
                                } catch {
                                    self.errorHandler.handle(error, while: "switching hub")
                                }
                            } else {
                                self.currentHub = nil
                            }
                        }
                        self.connectedHubs.removeAll(where: {$0 == hub})
                    } label: {
                        Label("Disconnect from \(hub.name)", systemImage: "trash")
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(hub.name)
                                .bold()
                            Text("\(hub.host):\(String(hub.port))")
                                .foregroundStyle(.secondary)
                                .font(.footnote)
                        }
                        Spacer()
                        if self.currentHub == hub {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: DiscoverHubsView()) {
                    Label("Add Hub", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ConnectedHubsList(connectedHubs: [.mock])
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
