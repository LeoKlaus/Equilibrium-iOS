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
        
        return try await apiHandler.get(endpoint: .scenes)
    }
    
    func getScene(_ id: Int) async throws -> Scene {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(endpoint: .scene(id: id))
    }
    
    func createScene(_ scene: Scene) async throws -> Scene {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .scenes, object: scene)
    }
    
    func updateScene(_ scene: Scene) async throws -> Scene {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        guard let sceneId = scene.id else {
            throw HubConnectionError.invalidInput
        }
        
        return try await apiHandler.patch(endpoint: .scene(id: sceneId), object: scene)
    }
    
    func deleteScene(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.delete(endpoint: .scene(id: id))
    }
    
    func getCurrentScene() async throws -> SceneStatusReport {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(endpoint: .currentScene)
    }
    
    func setCurrentScene(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .setCurrentScene(id: id))
    }
    
    func startScene(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .startScene(id: id))
    }
    
    func stopCurrentScene() async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.post(endpoint: .stopCurrentScene)
    }
}
