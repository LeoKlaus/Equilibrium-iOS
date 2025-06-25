//
//  ImagePicker.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 25.06.25.
//

/*import SwiftUI
import EasyErrorHandling
import EquilibriumAPI

struct ImagePicker: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @Binding var selectedImage: UserImage?
    
    @State private var images: [UserImage] = []
    @State private var isLoading = true
    
    @State private var showUploadSheet: Bool = false
    
    @Sendable func getImages() async {
        do {
            self.images = try await connectionHandler.getImages()
            self.isLoading = false
        } catch {
            self.errorHandler.handle(error, while: "fetching images")
            self.isLoading = false
        }
    }
    
    var body: some View {
        List {
            if isLoading {
                HStack {
                    ProgressView()
                    Text("Loading images from hub...")
                }
                .task(getImages)
            } else {
                if self.images.isEmpty {
                    Text("No images found")
                }
                
                ForEach(self.images) { image in
                    Button {
                        self.selectedImage = image
                        self.dismiss()
                    } label: {
                        HStack {
                            ImageView(image: image)
                                .frame(width: 60, height: 60)
                            Text(image.filename)
                            Spacer()
                            if image.id == self.selectedImage?.id {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.accent)
                            }
                        }
                        .contentShape(.rect)
                    }
                    .foregroundStyle(.primary)
                }
                
                Button {
                    self.selectedImage = nil
                    self.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "xmark")
                            .frame(width: 60, height: 60)
                        Text("None")
                        Spacer()
                        if self.selectedImage == nil {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.accent)
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
        }
        .refreshable(action: self.getImages)
        .sheet(isPresented: $showUploadSheet) {
            UploadImageView()
                .presentationDetents([.medium])
                .onDisappear {
                    Task {
                        await getImages()
                    }
                }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    self.showUploadSheet.toggle()
                } label: {
                    Label("Add Image", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var image: UserImage? = nil
    ImagePicker(selectedImage: $image)
        .withErrorHandling()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
*/
