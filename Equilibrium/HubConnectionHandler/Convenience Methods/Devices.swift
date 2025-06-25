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
        
        self.devices = try await apiHandler.get(path: "/devices/")
    }
    
    func getDevice(_ id: Int) async throws -> Device {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(path: "/devices/\(id)/")
    }
    
    func createDevice(_ device: Device) async throws -> Device {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(path: "/devices/", object: device)
    }
    
    func updateDevice(_ device: Device) async throws -> Device {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        guard let deviceId = device.id else {
            throw HubConnectionError.invalidInput
        }
        
        return try await apiHandler.patch(path: "/devices/\(deviceId)", object: device)
    }
    
    func deleteDevice(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.delete(path: "/devices/\(id)")
    }
    
    func createCommandGroup(deviceId: Int, commandGroup: CommandGroup) async throws -> CommandGroup {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(path: "/devices/\(deviceId)/command_groups", object: commandGroup)
    }
    
    func deleteCommandGroup(commandGroupId: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.delete(path: "/devices/command_groups/\(commandGroupId)")
    }
    
    func getBleDevices() async throws -> [BleDevice] {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(path: "/devices/ble_devices")
    }
    
    func advertiseBle() async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(path: "/devices/start_ble_advertisement")
    }
    
    func pairBle() async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(path: "/devices/start_ble_pairing")
    }
    
    func connectBleDevices(_ address: String) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(path: "/devices/connect_ble/\(address)")
    }
    
    func disconnectBleDevices() async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(path: "/devices/disconnect_ble_devices")
    }
}
