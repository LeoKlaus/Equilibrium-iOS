//
//  Commands.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 24.06.25.
//

import Foundation
import EquilibriumAPI

extension HubConnectionHandler {
    func getCommands() async throws -> [Command] {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(endpoint: .commands)
    }
    
    func getCommand(_ id: Int) async throws -> Command {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(endpoint: .command(id: id))
    }
    
    func createCommand(_ command: Command) async throws -> Command {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .commands, object: command)
    }
    
    func deleteCommand(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.delete(endpoint: .command(id: id))
    }
    
    func sendCommand(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .sendCommand(id: id))
    }
}
