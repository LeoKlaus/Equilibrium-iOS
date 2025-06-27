//
//  Devices.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 24.06.25.
//

import Foundation
import EquilibriumAPI

extension HubConnectionHandler {
    
    func getDevices() async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        self.devices = try await apiHandler.get(endpoint: .devices)
    }
    
    func getDevice(_ id: Int) async throws -> Device {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(endpoint: .device(id: id))
    }
    
    func createDevice(_ device: Device) async throws -> Device {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .devices, object: device)
    }
    
    func updateDevice(_ device: Device) async throws -> Device {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        guard let deviceId = device.id else {
            throw HubConnectionError.invalidInput
        }
        
        return try await apiHandler.patch(endpoint: .device(id: deviceId), object: device)
    }
    
    func deleteDevice(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.delete(endpoint: .device(id: id))
    }
}
