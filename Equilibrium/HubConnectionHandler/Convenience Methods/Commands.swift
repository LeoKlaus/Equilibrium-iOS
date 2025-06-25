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
        
        return try await apiHandler.get(path: "/commands/")
    }
    
    func getCommand(_ id: Int) async throws -> Command {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(path: "/commands/\(id)/")
    }
    
    func createCommand(_ command: Command) async throws -> Command {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(path: "/commands/", object: command)
    }
    
    func deleteCommand(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.delete(path: "/commands/\(id)")
    }
    
    func sendCommand(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(path: "/commands/\(id)/send")
    }
}
