//
//  Equilibrium_WidgetsLiveActivity.swift
//  Equilibrium-Widgets
//
//  Created by Leo Wehrfritz on 29.06.25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Equilibrium_WidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Equilibrium_WidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Equilibrium_WidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Equilibrium_WidgetsAttributes {
    fileprivate static var preview: Equilibrium_WidgetsAttributes {
        Equilibrium_WidgetsAttributes(name: "World")
    }
}

extension Equilibrium_WidgetsAttributes.ContentState {
    fileprivate static var smiley: Equilibrium_WidgetsAttributes.ContentState {
        Equilibrium_WidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Equilibrium_WidgetsAttributes.ContentState {
         Equilibrium_WidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Equilibrium_WidgetsAttributes.preview) {
   Equilibrium_WidgetsLiveActivity()
} contentStates: {
    Equilibrium_WidgetsAttributes.ContentState.smiley
    Equilibrium_WidgetsAttributes.ContentState.starEyes
}
