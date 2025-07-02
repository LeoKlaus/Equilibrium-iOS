//
//  Macros.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 24.06.25.
//

import Foundation
import EquilibriumAPI

extension HubConnectionHandler {
    func getMacros() async throws -> [Macro] {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(endpoint: .macros)
    }
    
    func getMacro(_ id: Int) async throws -> Macro {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(endpoint: .macro(id: id))
    }
    
    func createMacro(_ macro: Macro) async throws -> Macro {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .macros, object: macro)
    }
    
    func updateMacro(_ macro: Macro) async throws -> Macro {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        guard let macroId = macro.id else {
            throw HubConnectionError.invalidInput
        }
        
        return try await apiHandler.patch(endpoint: .macro(id: macroId), object: macro)
    }
    
    func deleteMacro(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.delete(endpoint: .macro(id: id))
    }
    
    func sendMacro(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .sendMacro(id: id))
    }
}
