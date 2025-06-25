//
//  BluetoothDeviceListItem.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 24.06.25.
//

import SwiftUI
import EquilibriumAPI

struct BluetoothDeviceListItem: View {
    
    let device: BleDevice
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(device.name)
                    .bold()
                Text(device.address)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(device.connected ? "Connected" : "Not connected")
                    .foregroundStyle(device.connected ? .green : .red)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(device.paired ? "Paired" : "Not paired")
                    .foregroundStyle(device.paired ? .green : .red)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    List {
        BluetoothDeviceListItem(device: BleDevice(name: "Windows PC", address: "XX:XX:XX:XX:XX:XX", connected: true, paired: true))
        
        BluetoothDeviceListItem(device: BleDevice(name: "Living Room Apple TV", address: "XX:XX:XX:XX:XX:XX", connected: false, paired: false))
        
        BluetoothDeviceListItem(device: BleDevice(name: "Playstation 5", address: "XX:XX:XX:XX:XX:XX", connected: false, paired: true))
    }
}
