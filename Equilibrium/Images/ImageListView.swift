//
//  ImageListView.swift
//  Equilibrium
//
//  Created by Leo Wehrfritz on 23.06.25.
//

import SwiftUI
import EquilibriumAPI
import EasyErrorHandling

struct ImageListView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(HubConnectionHandler.self) var connectionHandler
    
    @State private var images: [UserImage] = []
    @State private var isLoading = true
    
    @State private var showUploadSheet: Bool = false
    
    @State private var showDeleteConfirmation: Bool = false
    @State private var imagesToDelete: IndexSet? = nil
    
    let isPicker: Bool
    @Binding var selectedImage: UserImage?
    
    init() {
        self._selectedImage = .constant(nil)
        self.isPicker = false
    }
    
    init(selectedImage: Binding<UserImage?>) {
        self._selectedImage = selectedImage
        self.isPicker = true
    }
    
    @Sendable func getImages() async {
        do {
            self.images = try await connectionHandler.getImages()
            self.isLoading = false
        } catch {
            self.errorHandler.handle(error, while: "fetching images")
            self.isLoading = false
        }
    }
    
    func deleteImage(_ image: UserImage) {
        if let index = self.images.firstIndex(of: image) {
            self.imagesToDelete = IndexSet(integer: index)
            self.showDeleteConfirmation = true
        }
    }
    
    func deleteImages() {
        guard let imagesToDelete else {
            return
        }
        Task {
            do {
                for index in imagesToDelete {
                    if let imageId = images[index].id {
                        try await self.connectionHandler.deleteImage(imageId)
                    }
                }
                images.remove(atOffsets: imagesToDelete)
            } catch {
                self.errorHandler.handle(error, while: "deleting images")
            }
            self.imagesToDelete = nil
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
                    if isPicker {
                        Button {
                            self.selectedImage = image
                            self.dismiss()
                        } label: {
                            HStack {
                                ImageView(image: image)
                                    .frame(width: 60, height: 60)
                                Text(image.filename)
                                Spacer()
                                if selectedImage?.id == image.id {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.accent)
                                }
                            }
                            .contentShape(.rect)
                        }
                        .foregroundStyle(.primary)
                    } else {
                        Menu {
                            Button(role: .destructive) {
                                deleteImage(image)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            HStack {
                                ImageView(image: image)
                                    .frame(width: 60, height: 60)
                                Text(image.filename)
                                Spacer()
                            }
                            .contentShape(.rect)
                        }
                        .foregroundStyle(.primary)
                    }
                }
                .onDelete(perform: { index in
                    self.imagesToDelete = index
                    self.showDeleteConfirmation = true
                })
                
                if isPicker {
                    Button {
                        self.selectedImage = nil
                        self.dismiss()
                    } label: {
                        HStack {
                            Text("None")
                            Spacer()
                            if selectedImage == nil {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.accent)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .refreshable(action: self.getImages)
        .alert("Delete \(imagesToDelete?.count ?? 0) images?", isPresented: $showDeleteConfirmation) {
            Button("Yes", role: .destructive, action: deleteImages)
            Button("Cancel", role: .cancel) {
                self.imagesToDelete = nil
            }
        }
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
    ImageListView()
        .withErrorHandling()
        .environment(MockHubConnectionHandler() as HubConnectionHandler)
}
