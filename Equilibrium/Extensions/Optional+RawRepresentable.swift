//
//  Optional+RawRepresentable.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import Foundation

extension Optional: @retroactive RawRepresentable where Wrapped: Codable {
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self) else {
            return "{}"
        }
        return String(decoding: data, as: UTF8.self)
    }
    
    public init?(rawValue: String) {
        guard let value = try? JSONDecoder().decode(Self.self, from: Data(rawValue.utf8)) else {
            return nil
        }
        self = value
    }
}
