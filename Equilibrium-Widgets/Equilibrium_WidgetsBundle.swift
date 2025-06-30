//
//  Equilibrium_WidgetsBundle.swift
//  Equilibrium-Widgets
//
//  Created by Leo Wehrfritz on 29.06.25.
//

import WidgetKit
import SwiftUI

@main
struct Equilibrium_WidgetsBundle: WidgetBundle {
    var body: some Widget {
        Equilibrium_Widgets()
        if #available(iOS 18.0, *) {
            Equilibrium_WidgetsControl()
        }
        Equilibrium_WidgetsLiveActivity()
    }
}
