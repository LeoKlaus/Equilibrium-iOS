//
//  HubConnectionError.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

enum HubConnectionError: Error {
    case noApiHandler
    case couldntGetUserdefaults
    case invalidInput
    case invalidServerResponse
}
