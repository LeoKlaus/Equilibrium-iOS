//
//  String+SpacedStrings.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 26.06.25.
//

extension String {
    init(spacedStrings: [String?]) {
        self.init()
        for index in spacedStrings.indices {
            if index != (spacedStrings.count - 1), let string = spacedStrings[index] {
                self.append(string + " ")
            } else if let string = spacedStrings[index] {
                self.append(string)
            }
        }
    }
}
