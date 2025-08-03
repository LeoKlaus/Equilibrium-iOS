//
//  HubConnectionError.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import Foundation

enum HubConnectionError: LocalizedError {
    case noApiHandler
    case couldntGetUserdefaults
    case invalidInput
    case invalidServerResponse
    
    var errorDescription: String? {
        switch self {
        case .noApiHandler:
            "Couldn't access ApiHandler"
        case .couldntGetUserdefaults:
            "Couldn't access UserDefaults"
        case .invalidInput:
            "The given input was invalid"
        case .invalidServerResponse:
            "The server response was invalid or unexpected"
        }
    }
}
