//
//  SendCommandIntent.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 02.07.25.
//

import AppIntents
import EquilibriumAPI

struct SendCommandIntent: AppIntent {
    static let title: LocalizedStringResource = "Send a command to a device."
    static let description: IntentDescription? = "Sends the given command to the given device via the selected Hub."
    
    @Parameter(title: "Hub")
    var hub: DiscoveredService
    
    //@Parameter(title: "Device")
    //var device: Device?
    
    func perform() async throws -> some IntentResult {
        
        return .result()
    }
}

/*struct SendCommandToIntent: AppIntent {
    
    static let title: LocalizedStringResource = "Send a command to a device."
    static let description: IntentDescription? = "Sends the given command to the given device via the selected Hub."
    
    @Parameter(title: "Hub")
    var hub: ConnectedHub
    
    @Parameter(title: "Device")
    var device: HarmonyDevice
    
    @Parameter(title: "Command")
    var command: String?
    
    init() { }
    
    init(hub: ConnectedHub, device: HarmonyDevice, command: HarmonyControlGroupFunction?) {
        self.hub = hub
        self.device = device
        self.command = command?.action
    }
    
    func perform() async throws -> some IntentResult {
        
        guard let command else {
            throw SendCommandToDeviceViaWidgetIntentError.missingCommand
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "H:mm:ss.SSSS"
        
        UserDefaults(suiteName: "group.me.wehrfritz.Telefant")?.set("\(formatter.string(from: .now)) Received command for \(device.label ?? "")", forKey: "lastReceived")
        
        let params = [
            "status": "pressrelease",
            "timestamp": Date().timeIntervalSince1970*1000,
            "verb": "render",
            "action": command
        ] as [String : Any]
        
        do {
            try await HarmonyApiHandler.sendCommand(command: "vnd.logitech.harmony/vnd.logitech.harmony.engine?holdAction", params: params, to: hub.id)
            UserDefaults(suiteName: "group.me.wehrfritz.Telefant")?.set("\(formatter.string(from: .now)) Executed command \(command) successfully", forKey: "lastReceivedStatus")
        } catch {
            UserDefaults(suiteName: "group.me.wehrfritz.Telefant")?.set("\(formatter.string(from: .now)) Error: \(error.localizedDescription)", forKey: "lastReceivedStatus")
        }
        return .result()
    }
}
*/
