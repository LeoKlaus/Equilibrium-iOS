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
            
            Text(device.name)
                .font(.title3)
            
            Spacer()
        }
    }
}

#Preview {
    List {
        DeviceListItem(device: .mockTV)
        DeviceListItem(device: .mockAmplifier)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
