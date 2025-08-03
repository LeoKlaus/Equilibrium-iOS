//
//  ReloadAllWidgetsIntent.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 03.08.25.
//


import AppIntents
import WidgetKit

struct ReloadAllWidgetsIntent: AppIntent {
    
    static let title: LocalizedStringResource = "Reload all widgets"
    static let description: IntentDescription? = "Reloads all widgets."
    
    func perform() async throws -> some IntentResult {
        if #available (iOS 18.0, *) {
            ControlCenter.shared.reloadAllControls()
        }
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
