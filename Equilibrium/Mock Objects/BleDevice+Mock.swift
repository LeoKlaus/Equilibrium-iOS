//
//  BleDevice+Mock.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import EquilibriumAPI

extension BleDevice {
    static let mock = BleDevice(name: "Living Room Apple TV", address: "12:34:56:78:9A:BC", connected: false, paired: false)
}
