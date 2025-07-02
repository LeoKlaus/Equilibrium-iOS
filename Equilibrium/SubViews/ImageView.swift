//
//  ImageView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct ImageView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @AppStorage(UserDefaultKey.invertImagesInDarkMode.rawValue, store: UserDefaults(suiteName: .userDefaultGroup)) var invertImagesInDarkMode: Bool = true
    
    let image: UserImage
    
    @State private var imageData: Data?
    
    @Sendable func getImageData() async {
        guard let imageId = image.id else {
            return
        }
        do {
            self.imageData = try await self.connectionHandler.getImage(imageId)
        } catch {
            self.errorHandler.handle(error, while: "getting image data")
        }
    }
    
    var body: some View {
        VStack {
            if let imageData, let uiImage = UIImage(data: imageData) {
                if invertImagesInDarkMode && colorScheme == .dark {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .colorInvert()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else {
                ProgressView()
                    .task(getImageData)
            }
        }
    }
}

#Preview {
    ImageView(image: .mock)
        .frame(width: 60, height: 60)
        .withErrorHandling()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
