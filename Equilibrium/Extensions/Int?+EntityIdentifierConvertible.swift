//
//  Int?+EntityIdentifierConvertible.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import AppIntents

extension Int?: @retroactive EntityIdentifierConvertible {
    public var entityIdentifierString: String {
        if let self {
            String(self)
        } else {
            "nil"
        }
    }
    
    public static func entityIdentifier(for entityIdentifierString: String) -> Optional<Wrapped>? {
        Int(entityIdentifierString)
    }
}
