//
//  Images.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 24.06.25.
//

import Foundation
import EquilibriumAPI

extension HubConnectionHandler {
    func getImages() async throws -> [UserImage] {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(endpoint: .images)
    }
    
    func getImage(_ id: Int) async throws -> Data {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(endpoint: .image(id: id))
    }
    
    func uploadImage(fileURL: URL) async throws -> UserImage {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.postMultipartForm(endpoint: .images, fileURL: fileURL)
    }
    
    func deleteImage(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.delete(endpoint: .image(id: id))
    }
}
