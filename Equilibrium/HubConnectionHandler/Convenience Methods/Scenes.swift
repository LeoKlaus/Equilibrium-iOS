//
//  Scenes.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 24.06.25.
//

import Foundation
import EquilibriumAPI

extension HubConnectionHandler {
    func getScenes() async throws -> [Scene] {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(path: "/scenes/")
    }
    
    func getScene(_ id: Int) async throws -> Scene {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(path: "/scenes/\(id)/")
    }
    
    func createScene(_ scene: Scene) async throws -> Scene {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(path: "/scene/", object: scene)
    }
    
    func updateScene(_ scene: Scene) async throws -> Scene {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        guard let sceneId = scene.id else {
            throw HubConnectionError.invalidInput
        }
        
        return try await apiHandler.patch(path: "/scenes/\(sceneId)", object: scene)
    }
    
    func deleteScene(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.delete(path: "/scenes/\(id)")
    }
    
    func getCurrentScene() async throws -> SceneStatusReport {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(path: "/scenes/current")
    }
    
    func setCurrentScene(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(path: "/scenes/\(id)/set_current")
    }
    
    func startScene(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(path: "/scenes/\(id)/start")
    }
    
    func stopCurrentScene() async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(path: "/scenes/stop")
    }
}
