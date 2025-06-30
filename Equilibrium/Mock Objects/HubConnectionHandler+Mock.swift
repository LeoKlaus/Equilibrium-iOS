//
//  HubConnectionHandler+Mock.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import Foundation
import EquilibriumAPI

@Observable
class MockHubConnectionHandler: HubConnectionHandler {
    
    override init() {
        super.init()
        self.apiHandler = MockApiHandler()
    }
    
    init(sceneStatus: StatusReport) {
        super.init()
        self.apiHandler = MockApiHandler()
        self.currentSceneStatus = sceneStatus
    }
    
    //override var scenes: [Scene] = []
    
    //override var devices: [Device] = []
    /*override func getDevices() async throws -> [Device] {
        self.devices = [
            .mockTV
        ]
        return devices
    }*/
}
