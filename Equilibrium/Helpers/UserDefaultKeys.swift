//
//  UserDefaultKeys.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 28.06.25.
//

enum UserDefaultKey: String {
    case currentHub
    case connectedHubs
    case invertImagesInDarkMode
}

extension String {
    static let userDefaultGroup = "group.me.wehrfritz.Equilibrium"
}
