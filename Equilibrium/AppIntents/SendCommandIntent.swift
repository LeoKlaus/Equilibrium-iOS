//
//  SendCommandIntent.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 02.07.25.
//

import AppIntents
import EquilibriumAPI

struct SendCommandIntent: AppIntent {
    static let title: LocalizedStringResource = "Send a command that doesn't belong to a device."
    static let description: IntentDescription? = "Sends the given command via the selected hub."
    
    @Parameter(title: "Hub")
    var hub: DiscoveredService
    
    @Parameter(title: "Command")
    var command: Command
    
    func perform() async throws -> some IntentResult {
        let apiHandler = try EquilibriumAPIHandler(service: hub)
        
        guard let commandId = command.id else {
            return .result()
        }
        
        try await apiHandler.post(endpoint: .sendCommand(id: commandId))
        
        return .result()
    }
    
    init() { }
    
    init(hub: DiscoveredService, command: Command) {
        self.hub = hub
        self.command = command
    }
}
