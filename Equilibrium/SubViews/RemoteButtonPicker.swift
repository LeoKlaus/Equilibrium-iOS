//
//  RemoteButtonPicker.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import SwiftUI
import EquilibriumAPI

struct RemoteButtonPicker: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var button: RemoteButton
    var category: CommandGroupType? = nil
    
    var body: some View {
        List {
            if let categoryRepresentation = category?.represenation {
                Section(categoryRepresentation.name) {
                    ForEach(categoryRepresentation.buttons) { button in
                        pickerButton(button.name, systemImage: button.systemImage, command: button.button)
                    }
                }
            } else {
                ForEach(RemoteButton.allButtons) { category in
                    Section(category.name) {
                        ForEach(category.buttons) { button in
                            pickerButton(button.name, systemImage: button.systemImage, command: button.button)
                        }
                    }
                }
            }
        }
    }
    
    func pickerButton(_ name: LocalizedStringKey, systemImage: String, command: RemoteButton, iconColor: Color = .accent) -> some View {
        Button {
            self.button = command
            self.dismiss()
        } label: {
            HStack {
                Label {
                    Text(name)
                } icon: {
                    Image(systemName: systemImage)
                        .foregroundStyle(iconColor)
                }
                Spacer()
                if self.button == command {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.accent)
                }
            }
        }
        .foregroundStyle(.primary)
    }
}

#Preview("All") {
    @Previewable @State var button: RemoteButton = .other
    RemoteButtonPicker(button: $button)
}

#Preview("Navigation") {
    @Previewable @State var button: RemoteButton = .other
    RemoteButtonPicker(button: $button, category: .navigation)
}
