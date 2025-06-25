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
        
        return try await apiHandler.get(path: "/images/")
    }
    
    func getImage(_ id: Int) async throws -> Data {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.get(path: "/images/\(id)/")
    }
    
    func uploadImage(fileURL: URL) async throws -> UserImage {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.postMultipartForm(path: "/images/", fileURL: fileURL)
    }
    
    func deleteImage(_ id: Int) async throws {
        guard let apiHandler else {
            throw HubConnectionError.noApiHandler
        }
        
        return try await apiHandler.delete(path: "/images/\(id)")
    }
}
