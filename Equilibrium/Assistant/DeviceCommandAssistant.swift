//
//  DeviceCommandAssistant.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct DeviceCommandAssistant: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    let device: Device
    
    @State var currentCommandGroup: CommandGroupType = .power
    
    var body: some View {
        List {
            
            if self.currentCommandGroup == .power {
                Text("""
In the next steps, you will teach Equilibrium the different commands to control your \(device.name).
""")
            }
            
            Section {
                Text(self.currentCommandGroup.descriptionText)
            }
            
            Section {
                NavigationLink {
                    switch self.currentCommandGroup {
                    case .other:
                        List {
                            Text("\(device.name) is now ready to use!")
                            Button("Done") {
                                self.dismiss()
                            }
                        }
                    default:
                        CommandGroupView(device: self.device, commandGroup: self.currentCommandGroup)
                    }
                } label: {
                    Text("Add \(self.currentCommandGroup.localizedName) commands")
                        .foregroundStyle(.accent)
                }
                
                NavigationLink {
                    switch self.currentCommandGroup {
                    case .other:
                        List {
                            Text("\(device.name) is now ready to use!")
                            Button("Done") {
                                self.dismiss()
                            }
                        }
                    default:
                        DeviceCommandAssistant(device: self.device, currentCommandGroup: self.currentCommandGroup.nextType)
                    }
                } label: {
                    Text("This device doesn't have \(currentCommandGroup.localizedName) commands")
                        .foregroundStyle(.red)
                }
            }
        }
    }
    
    var powerCommandGroupSection: some View {
        Section {
            Text("""
In the next steps, you will teach Equilibrium the different commands to control your \(device.name).
This guide will ask for different groups of commands and create them in Equilibrium.

To begin, get the original remote of this device and check if it has any **Power** buttons:
- *Power Toggle*
- *Power On*
- *Power Off*
""")
        } footer: {
            Text("If you want to control the device via Bluetooth, select yes for any group you want to create commands for.")
        }
    }
    
    var volumeCommandGroupSection: some View {
        Section {
            Text("""
Does the remote have any **Volume** buttons:
- *Volume Up*
- *Volume Down*
- *Mute*
""")
        }
    }
    
    var navigationCommandGroupSection: some View {
        Section {
            
        }
    }
    
    var transportCommandGroupSection: some View {
        Section {
            
        }
    }
    
    var coloredButtonsCommandGroupSection: some View {
        Section {
            
        }
    }
    
    var numbersCommandGroupSection: some View {
        Section {
            
        }
    }
    
    var channelCommandGroupSection: some View {
        Section {
            
        }
    }
    
    var otherCommandGroupSection: some View {
        Section {
            
        }
    }
}

#Preview {
    NavigationStack {
        DeviceCommandAssistant(device: .mockTV)
    }
    .withErrorHandling()
    .environment(MockHubConnectionHandler() as HubConnectionHandler)
}

