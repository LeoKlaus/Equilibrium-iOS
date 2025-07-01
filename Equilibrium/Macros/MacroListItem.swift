//
//  MacroListItem.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 01.07.25.
//

import SwiftUI
import EquilibriumAPI

struct MacroListItem: View {
    
    let macro: Macro
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.macro.name ?? "")
                .bold()
            Text("\(macro.commands?.count ?? 0) commands")
                .foregroundStyle(.secondary)
                .font(.footnote)
        }
    }
}

#Preview {
    List {
        MacroListItem(macro: .mockStart)
    }
}
