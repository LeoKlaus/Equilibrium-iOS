//
//  DeviceListItem.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct DeviceListItem: View {
    
    let device: Device
    
    var body: some View {
        HStack {
            VStack {
                if let image = device.image {
                    ImageView(image: image)
                } else {
                    device.type.image
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(device.name)
                    .font(.title3)
                    .bold()
                Text(String(spacedStrings: [device.manufacturer, device.model]))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

#Preview {
    List {
        DeviceListItem(device: .mockTV)
        DeviceListItem(device: .mockAmplifier)
        DeviceListItem(device: Device(id: 3, name: "Test", manufacturer: nil, model: "Blenis", type: .other))
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
