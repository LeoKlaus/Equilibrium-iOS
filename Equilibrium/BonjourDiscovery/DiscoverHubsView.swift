//
//  DiscoverHubsView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct DiscoverHubsView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @AppStorage("connectedHubs", store: UserDefaults(suiteName: "group.me.wehrfritz.Equilibrium")) var connectedHubs: [DiscoveredService] = []
    
    
    let browser = ZeroconfBrowser()
    
    @State private var isTestingConnection: Bool = false
    @State private var loadingLong: Bool = false
    @State private var manualConfiguration: Bool = false
    
    @State private var name: String = "Equilibrium"
    @State private var host: String = ""
    @State private var port: Int = 8000
    
    func testConnection(name: String, host: String, port: Int) {
        self.isTestingConnection = true
        Task {
            do {
                _ = try await EquilibriumAPIHandler.testConnection(host: host, port: port)
                let newHub = DiscoveredService(name: name, host: host, port: port)
                DispatchQueue.main.async {
                    self.isTestingConnection = false
                    self.connectedHubs.append(newHub)
                }
                try connectionHandler.switchToHub(newHub)
            } catch {
                DispatchQueue.main.async {
                    self.isTestingConnection = false
                    self.errorHandler.handle(error, while: "Testing connection to the hub", blockUserInteraction: true)
                }
            }
        }
    }
    
    let portFormatter: NumberFormatter
    
    init() {
        portFormatter = NumberFormatter()
        portFormatter.numberStyle = .decimal
        portFormatter.groupingSeparator = ""
    }
    
    var body: some View {
        VStack {
            Spacer(minLength: 300)
            if manualConfiguration {
                manualConfigurationPage
            } else {
                browserPage
            }
        }
        .onAppear {
            self.browser.startBrowsing()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    self.loadingLong = true
                }
            }
        }
        .onDisappear(perform: self.browser.stopBrowsing)
    }
    
    var manualConfigurationPage: some View {
        VStack {
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Name:")
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                        .padding(.leading, 5)
                    TextField("Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Host:")
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                            .padding(.leading, 5)
                        TextField("192.168.0.123", text: $host)
                            .textFieldStyle(.roundedBorder)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Port:")
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                            .padding(.leading, 5)
                        TextField("Port", value: $port, formatter: portFormatter)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 80)
                    }
                }
            }
            .padding()
            HStack {
                Button("Back") {
                    withAnimation {
                        manualConfiguration.toggle()
                    }
                }.buttonStyle(.bordered)
                Button("Connect") {
                    self.testConnection(name: self.name, host: self.host, port: self.port)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isTestingConnection)
            }
        }
    }
    
    var browserPage: some View {
        VStack {
            Text("Discovered Hubs:")
                .font(.headline)
            ScrollView {
                if browser.discoveredServices.isEmpty {
                    VStack {
                        Text(loadingLong ? "This is taking longer than expected. If you know your instance IP and port, use the manual configuration option below." : "Looking for Equilibrium instances in your network...").padding(.horizontal)
                        ProgressView()
                    }
                    .foregroundStyle(.secondary)
                }
                ForEach(browser.discoveredServices) { service in
                    Button {
                        self.testConnection(name: service.name, host: service.host, port: service.port)
                    } label: {
                        DiscoveredServiceView(service: service)
                    }
                    .padding()
                    .disabled(isTestingConnection)
                }
            }
            Button("Manual configuration") {
                withAnimation {
                    manualConfiguration.toggle()
                }
            }.buttonStyle(.bordered)
        }
    }
}

#Preview {
    DiscoverHubsView()
}
