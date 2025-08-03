//
//  Widget+promptsForUserConfigurationIfPossible.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//

import SwiftUI
import WidgetKit

extension WidgetConfiguration {
    func promptsForUserConfigurationIfPossible() -> some WidgetConfiguration {
        if #available(iOS 18.0, *) {
            return self.promptsForUserConfiguration()
        } else {
            return self
        }
    }
}
