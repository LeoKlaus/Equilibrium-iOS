//
//  EntityError.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import Foundation

enum EntityError: LocalizedError {
    /// No hub was selected
    case noHubSelected
    
    /// Command has no id
    case commandHasNoId
    
    public var errorDescription: String? {
        switch self {
        case .noHubSelected:
            "No hub was selected"
        case .commandHasNoId:
            "The selected command has no Id"
        }
    }
}
