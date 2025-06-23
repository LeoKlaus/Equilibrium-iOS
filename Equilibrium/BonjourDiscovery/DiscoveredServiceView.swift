//
//  DiscoveredServiceView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import SwiftUI

struct DiscoveredServiceView: View {
    
    let service: DiscoveredService
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(service.name)
                .font(.headline)
            Text("\(service.host):\(String(service.port))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}

#Preview {
    ScrollView {
        DiscoveredServiceView(service: DiscoveredService(name: "Living Room Hub", host: "192.168.0.123", port: 8000))
            .padding(.horizontal)
        DiscoveredServiceView(service: DiscoveredService(name: "Bedroom Hub", host: "192.168.0.230", port: 8000))
            .padding(.horizontal)
    }
}
