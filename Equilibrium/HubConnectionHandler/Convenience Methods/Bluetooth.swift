//
//  Bluetooth.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 26.06.25.
//

import EquilibriumAPI

extension HubConnectionHandler {
    func getBleDevices() async throws -> [BleDevice] {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(endpoint: .bluetoothDevices)
    }
    
    func advertiseBle() async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .bluetoothStartAdvert)
    }
    
    func pairBle() async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .bluetoothStartPairing)
    }
    
    func connectBleDevices(_ address: String) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .bluetoothConnect(address: address))
    }
    
    func disconnectBleDevices() async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .bluetoothDisconnect)
    }
}
